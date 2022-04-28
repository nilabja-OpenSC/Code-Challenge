module "project-vpc" {
    source      = "./module/vpc"

    ENVIRONMENT = var.ENVIRONMENT
    AWS_REGION  = var.AWS_REGION
}

module "project-webserver" {
    source      = "./webserver"

    ENVIRONMENT = var.ENVIRONMENT
    AWS_REGION  = var.AWS_REGION
    vpc_app_private_subnet1 = module.project-vpc.private_APP_subnet1_id
    vpc_app_private_subnet2 = module.project-vpc.private_APP_subnet2_id
    vpc_db_private_subnet1 = module.project-vpc.private_DB_subnet1_id
    vpc_db_private_subnet2 = module.project-vpc.private_DB_subnet2_id
    vpc_id = module.project-vpc.my_vpc_id
    vpc_public_subnet1 = module.project-vpc.public_web_subnet1_id
    vpc_public_subnet2 = module.project-vpc.public_web_subnet2_id
    private_db_cidr_subnet1 = module.project-vpc.private_db_cidr_subnet1
    private_db_cidr_subnet2 = module.project-vpc.private_db_cidr_subnet2

}

#Define Provider
provider "aws" {
  region = var.AWS_REGION
}

output "web-load_balancer_output" {
  description = "WEB Load Balancer"
  value       = module.project-webserver.web-load_balancer_output
}

