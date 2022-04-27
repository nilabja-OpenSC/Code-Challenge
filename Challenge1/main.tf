
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

#Define Provider
provider "aws" {
  region = var.AWS_REGION
}

output "load_balancer_output" {
  description = "Load Balancer"
  value       = module.project-webserver.load_balancer_output
}