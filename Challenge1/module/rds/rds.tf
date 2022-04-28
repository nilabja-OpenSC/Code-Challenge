
#Define Subnet Group for RDS Service
resource "aws_db_subnet_group" "project-rds-subnet-group" {

    name          = "${var.ENVIRONMENT}-project-db-snet"
    description   = "Allowed subnets for DB cluster instances"
    subnet_ids    = [
      "${var.vpc_db_private_subnet1}",
      "${var.vpc_db_private_subnet2}",
    ]
    tags = {
        Name      = "${var.ENVIRONMENT}_project_db_subnet"
    }
}

#Define Security Groups for RDS Instances
resource "aws_security_group" "project-rds-sg" {

  name = "${var.ENVIRONMENT}-project-rds-sg"
  description = "Created by project"
  vpc_id      = var.vpc_id

  ingress {
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    cidr_blocks = [
      "${var.private_db_cidr_subnet1}",
      "${var.private_db_cidr_subnet2}",
    ]

  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

    tags = {
    Name = "${var.ENVIRONMENT}-project-rds-sg"
   }
}

resource "aws_db_instance" "project-rds" {
  identifier = "${var.ENVIRONMENT}-project-rds"
  allocated_storage = var.project_RDS_ALLOCATED_STORAGE
  storage_type = "gp2"
  engine = var.project_RDS_ENGINE
  engine_version = var.project_RDS_ENGINE_VERSION
  instance_class = var.DB_INSTANCE_CLASS
  backup_retention_period = var.BACKUP_RETENTION_PERIOD
  publicly_accessible = var.PUBLICLY_ACCESSIBLE
  username = var.project_RDS_USERNAME
  password = var.project_RDS_PASSWORD
  vpc_security_group_ids = [aws_security_group.project-rds-sg.id]
  db_subnet_group_name = aws_db_subnet_group.project-rds-subnet-group.name
  multi_az = "false"
}

output "rds_prod_endpoint" {
  value = aws_db_instance.project-rds.endpoint
}