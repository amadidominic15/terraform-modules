resource "aws_launch_template" "nodes" {
  name_prefix = "${var.cluster_name}-nodes-"
  vpc_security_group_ids = [ var.node_security_group_id ]
  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size           = 50
      volume_type           = "gp3"
      encrypted             = true
      delete_on_termination = true
    }
  }
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.cluster_name}-node"
    }
  }
}

resource "aws_eks_node_group" "node_group" {
  cluster_name    = aws_eks_cluster.eks.name
  node_group_name = "${var.cluster_name}-managed-ng"
  node_role_arn = var.node_role_arn
  subnet_ids = var.private_subnet_ids
  capacity_type  = "ON_DEMAND"
  instance_types = var.node_instance_types
  scaling_config {
    min_size     = var.node_min_size
    desired_size = var.node_desired_size
    max_size     = var.node_max_size
  }
  launch_template {
    id      = aws_launch_template.nodes.id
    version = aws_launch_template.nodes.latest_version
  }
  update_config {
    max_unavailable = 1
  }
  lifecycle {
    precondition {
      condition = (
        var.node_min_size <= var.node_desired_size &&
        var.node_desired_size <= var.node_max_size
      )
      error_message = "Node sizes must satisfy: node_min_size <= node_desired_size <= node_max_size."
    }
  }
  labels = {
    workload = "general"
  }
  depends_on = [
    aws_eks_cluster.eks,
    aws_eks_addon.eks_addons
  ]
}