
resource "aws_db_subnet_group" "default" {
  name       = "main"
  subnet_ids = var.database_subnets

  tags = merge(var.tags, {
    Name = "DB subnet group"
  })
}

resource "aws_security_group" "rds" {
  name   = "example rds"
  vpc_id = data.aws_vpc.selected.id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "rds"
  })
}

resource "aws_db_instance" "this" {
  instance_class         = var.db_instance_type
  allocated_storage      = var.db_allocated_storage
  engine                 = var.db_engine
  engine_version         = var.db_engine_version
  username               = var.db_username
  password               = var.db_password
  db_subnet_group_name   = aws_db_subnet_group.default.name
  vpc_security_group_ids = [aws_security_group.rds.id]
  skip_final_snapshot    = true
  multi_az               = true

  tags = var.tags
}

