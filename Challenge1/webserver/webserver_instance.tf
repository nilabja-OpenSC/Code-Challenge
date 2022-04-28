# module "project-vpc" {
#     source      = "../module/vpc"

#     ENVIRONMENT = var.ENVIRONMENT
#     AWS_REGION  = var.AWS_REGION
# }

module "project-appserver" {
    source      = "../module/appserver"

    ENVIRONMENT = var.ENVIRONMENT
    AWS_REGION  = var.AWS_REGION
    vpc_id = var.vpc_id
    vpc_app_private_subnet1 = var.vpc_app_private_subnet1
    vpc_app_private_subnet2 = var.vpc_app_private_subnet2
    vpc_db_private_subnet1 = var.vpc_db_private_subnet1
    vpc_db_private_subnet2 = var.vpc_db_private_subnet2
    private_db_cidr_subnet1 = var.private_db_cidr_subnet1
    private_db_cidr_subnet2 = var.private_db_cidr_subnet2

}

resource "aws_security_group" "project_webservers"{
  tags = {
    Name = "${var.ENVIRONMENT}-project-webservers"
  }
  
  name          = "${var.ENVIRONMENT}-project-webservers"
  description   = "Created by project"
  vpc_id        = var.vpc_id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["${var.SSH_CIDR_WEB_SERVER}"]

  }

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }
  
  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }
  
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#Resource key pair
resource "aws_key_pair" "project_key" {
  key_name      = "project_key"
  public_key    = file(var.public_key_path)
}

resource "aws_launch_template" "launch_template_webserver" {
  name   = "launch_template_webserver"
# image_id      = data.aws_ami.latest-ubuntu.id
  image_id      = lookup(var.AMIS, var.AWS_REGION)
  instance_type = var.INSTANCE_TYPE
  user_data = base64encode("install_nginx.sh")
  vpc_security_group_ids = [aws_security_group.project_webservers.id]
  key_name = aws_key_pair.project_key.key_name
  
  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      volume_type = "gp2"
      volume_size = 20
    }
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "web-lt"
    }
  }

}

resource "aws_autoscaling_group" "project_webserver" {
  name                      = "project_WebServers"
  max_size                  = 2
  min_size                  = 1
  health_check_grace_period = 30
  health_check_type         = "EC2"
  desired_capacity          = 1
  force_delete              = true
  launch_template {
    id      = aws_launch_template.launch_template_webserver.id
    version = "$Latest"
  }
  vpc_zone_identifier       = ["${var.vpc_public_subnet1}", "${var.vpc_public_subnet2}"]
  target_group_arns         = [aws_lb_target_group.load-balancer-target-group.arn]
}

#Application load balancer for web server
resource "aws_lb" "project-load-balancer" {
  name               = "${var.ENVIRONMENT}-project-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.project_webservers_alb.id]
  subnets            = ["${var.vpc_public_subnet1}", "${var.vpc_public_subnet2}"]

}

# Add Target Group
resource "aws_lb_target_group" "load-balancer-target-group" {
  name     = "load-balancer-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

# Adding HTTP listener
resource "aws_lb_listener" "webserver_listner" {
  load_balancer_arn = aws_lb.project-load-balancer.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.load-balancer-target-group.arn
    type             = "forward"
  }
}

output "web-load_balancer_output" {
  value = aws_lb.project-load-balancer.dns_name
}

output "app-load_balancer_output" {
  description = "APP Load Balancer"
  value       = module.project-appserver.app-load_balancer_output
}