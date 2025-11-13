resource "aws_db_instance" "this" {
  identifier          = var.identifier
  engine              = var.engine
  instance_class      = var.instance_class
  allocated_storage   = var.allocated_storage
  username            = var.username
  password            = var.password
  vpc_security_group_ids = var.security_group_ids
  skip_final_snapshot = var.skip_final_snapshot

  tags = var.tags
}

