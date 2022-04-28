module "project-webserver" {
    source      = "./webserver"

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

