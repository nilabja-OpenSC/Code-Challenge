
module "project-vpc" {
    source      = "./module/vpc"

    ENVIRONMENT = var.ENVIRONMENT
    AWS_REGION  = var.AWS_REGION
}

module "project-webserver" {
    source      = "./webserver"

    ENVIRONMENT = var.ENVIRONMENT
    AWS_REGION  = var.AWS_REGION
    vpc_private_subnet1 = module.project-vpc.private_subnet1_id
    vpc_private_subnet2 = module.project-vpc.private_subnet2_id
    vpc_id = module.project-vpc.my_vpc_id
    vpc_public_subnet1 = module.project-vpc.public_subnet1_id
    vpc_public_subnet2 = module.project-vpc.public_subnet2_id

}

module "project-appserver" {
    source      = "./module/webserver"

    ENVIRONMENT = var.ENVIRONMENT
    AWS_REGION  = var.AWS_REGION

}

#Define Provider
provider "aws" {
  region = var.AWS_REGION
}

output "web-load_balancer_output" {
  description = "WEB Load Balancer"
  value       = module.project-webserver.web-load_balancer_output
}

output "app-load_balancer_output" {
  description = "APP Load Balancer"
  value       = module.project-appserver.app-load_balancer_output
}