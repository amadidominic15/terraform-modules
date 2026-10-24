resource "aws_ecs_cluster" "ecs_cluster" {
  name = var.cluster_name
  setting {
    name  = "containerInsights"
    value = var.enable_container_insights ? "enabled" : "disabled"
  }
  tags = {
    Name = "${var.cluster_name}-ecs-cluster"
  }
}

resource "aws_cloudwatch_log_group" "service" {
  for_each          = var.services
  name              = "/ecs/${var.cluster_name}/${each.key}"
  retention_in_days = var.log_retention_days
  tags = {
    Name = "${var.cluster_name}-log-group"
  }
}

resource "aws_ecs_task_definition" "service" {
  for_each                 = var.services
  family                   = "${var.cluster_name}-${each.key}"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = each.value.cpu
  memory                   = each.value.memory
  execution_role_arn       = var.task_execution_role_arn
  task_role_arn            = each.value.task_role_arn
  container_definitions = jsonencode([
    {
      name      = each.key
      image     = each.value.image
      essential = true

      portMappings = [
        {
          containerPort = each.value.container_port
          protocol      = "tcp"
        }
      ]
      environment = [
        for name, value in each.value.environment : {
          name  = name
          value = value
        }
      ]
      secrets = [
        for name, arn in each.value.secrets : {
          name      = name
          valueFrom = arn
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.service[each.key].name
          "awslogs-region"        = var.aws_region
          "awslogs-stream-prefix" = "ecs"
        }
      }
      readonlyRootFilesystem = true
      linuxParameters = {
        initProcessEnabled = true
      }
    }
  ])
  tags = {
    Name = "${var.cluster_name}-ecs-task-definition"
  }
}

# Application Load Balancer
# --------------------
resource "aws_lb" "ecs_alb" {
  name                       = "${var.cluster_name}-alb"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [var.alb_security_group_id]
  subnets                    = var.public_subnet_ids
  enable_deletion_protection = var.enable_alb_deletion_protection
  tags = merge(var.tags, {
    Name = "${var.cluster_name}-alb"
  })
}

resource "aws_lb_target_group" "ecs_tg" {
  for_each    = var.services
  name        = "${var.cluster_name}-${each.key}"
  port        = each.value.container_port
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id
  health_check {
    enabled             = true
    path                = each.value.health_check_path
    protocol            = "HTTP"
    matcher             = "200-399"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 3
  }
  tags = merge(var.tags, {
    Name = "${var.cluster_name}-${each.key}-target-group"
  })
}

# Application Load Balancer - HTTPS
# --------------------
resource "aws_lb_listener" "ecs_listener_https" {
  load_balancer_arn = aws_lb.ecs_alb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.acm_certificate_arn

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "Not found"
      status_code  = "404"
    }
  }
  tags = var.tags
}

# Optional: redirect HTTP (port 80) to HTTPS
resource "aws_lb_listener" "ecs_listener_http" {
  load_balancer_arn = aws_lb.ecs_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      protocol    = "HTTPS"
      port        = "443"
      status_code = "HTTP_301"
    }
  }
  tags = var.tags
}

# Route requests to the correct ECS service.
resource "aws_lb_listener_rule" "ecs_service" {
  for_each     = var.services
  listener_arn = aws_lb_listener.ecs_listener_https.arn
  priority     = 100 + index(sort(keys(var.services)), each.key)
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs_tg[each.key].arn
  }
  condition {
    path_pattern {
      values = [each.value.path_pattern]
    }
  }
  tags = var.tags
}

resource "aws_ecs_service" "service" {
  for_each                           = var.services
  name                               = "${var.cluster_name}-${each.key}"
  cluster                            = aws_ecs_cluster.ecs_cluster.id
  task_definition                    = aws_ecs_task_definition.service[each.key].arn
  desired_count                      = each.value.desired_count
  launch_type                        = "FARGATE"
  platform_version                   = "LATEST"
  enable_execute_command             = false
  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent         = 200
  health_check_grace_period_seconds  = 120
  wait_for_steady_state              = true
  network_configuration {
    subnets          = var.private_subnet_ids
    security_groups  = var.security_group_ids
    assign_public_ip = false
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.ecs_tg[each.key].arn
    container_name   = each.key
    container_port   = each.value.container_port
  }
  depends_on = [
    aws_lb_listener.ecs_listener_https,
    aws_lb_listener_rule.ecs_service
  ]
  lifecycle {
    ignore_changes = [desired_count]
  }
  tags = merge(var.tags, {
    Name = "${var.cluster_name}-${each.key}-service"
  })
}
