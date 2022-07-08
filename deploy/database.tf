resource "aws_db_subnet_group" "main" {
  name = "${local.prefix}-main"
  subnet_ids = [
    # AcademySharedInfraStack/SainsburysSharedVpc/privateSubnet1
    "subnet-03f1b73d915b12b0d",
    # AcademySharedInfraStack/SainsburysSharedVpc/privateSubnet2
    "subnet-02d1e63f3fc1ada51",
  ]

  tags = merge(
    local.common_tags,
    tomap({ "Name" = "${local.prefix}-main" })
  )
}

resource "aws_security_group" "rds" {
  description = "Allow access to the RDS database instance"
  name        = "${local.prefix}-rds-inbound-access"
  # AcademySharedInfraStack/SainsburysSharedVpc
  vpc_id = "vpc-0e296a5c8aac14d8c"

  ingress {
    protocol  = "tcp"
    from_port = 5432
    to_port   = 5432

    security_groups = [
      aws_security_group.bastion.id
    ]
  }

  tags = local.common_tags
}

resource "aws_db_instance" "main" {
  identifier              = "${local.prefix}-db"
  name                    = var.db_name
  allocated_storage       = 20
  storage_type            = "gp2"
  engine                  = "postgres"
  engine_version          = "14.2"
  instance_class          = "db.t3.micro"
  db_subnet_group_name    = aws_db_subnet_group.main.name
  password                = var.db_password
  username                = var.db_username
  backup_retention_period = 0
  multi_az                = false
  skip_final_snapshot     = true
  vpc_security_group_ids  = [aws_security_group.rds.id]

  tags = merge(
    local.common_tags,
    tomap({ "Name" = "${local.prefix}-main" })
  )
}
