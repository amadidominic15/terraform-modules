resource "aws_db_subnet_group" "db_subnet_group" {
  name        = "${var.name_prefix}-subnet-group"
  description = "Private subnet group for $${var.name_prefix}-db"
  subnet_ids  = var.private_subnet_ids
  tags = merge(var.tags, {
    Name = "${var.name_prefix}-db-subnet-group"
  })
}

resource "aws_db_instance" "db_instance" {
  identifier = "${var.name_prefix}-db"

  # Database engine
  engine         = var.rds_engine
  engine_version = var.rds_engine_version
  instance_class = var.rds_instance_class
  db_name        = var.db_name
  username       = var.master_username
  port           = var.port

  # RDS generates and manages the master password.
  # Never define password or password_wo with this enabled.
  manage_master_user_password = true

  # Storage
  allocated_storage     = var.allocated_storage
  max_allocated_storage = var.max_allocated_storage
  storage_type          = "gp3"
  storage_encrypted     = true
  kms_key_id            = var.storage_kms_key_id

  # Private network access
  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group.name
  vpc_security_group_ids = var.vpc_security_group_ids
  publicly_accessible    = false
  network_type           = "IPV4"

  # Availability and recovery
  multi_az                   = var.multi_az
  backup_retention_period    = var.backup_retention_period
  backup_window              = var.backup_window
  maintenance_window         = var.maintenance_window
  copy_tags_to_snapshot      = true
  auto_minor_version_upgrade = true
  # Security and lifecycle
  deletion_protection       = var.deletion_protection
  skip_final_snapshot       = false
  final_snapshot_identifier = "${var.name_prefix}-db-final"
  delete_automated_backups  = false

  # Monitoring
  monitoring_interval             = var.monitoring_interval
  monitoring_role_arn             = var.monitoring_role_arn
  enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports
  apply_immediately               = false # Avoid applying changes to production immediately by default.
  tags = merge(var.tags, {
    Name = "${var.name_prefix}-db-monitoring"
  })

  lifecycle {
    prevent_destroy = true
  }
}
