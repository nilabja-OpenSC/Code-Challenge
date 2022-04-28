variable "AWS_REGION" {
    type        = string
    default     = "us-east-2"
}

variable "project_VPC_CIDR_BLOC" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "project_VPC_PUBLIC_SUBNET1_CIDR_BLOCK" {
  description = "The CIDR block for the WEB Subnet1 in VPC"
  type        = string
  default     = "10.0.101.0/24"
}

variable "project_VPC_PUBLIC_SUBNET2_CIDR_BLOCK" {
  description = "The CIDR block for the WEB Subnet2 in VPC"
  type        = string
  default     = "10.0.102.0/24"
}

variable "project_VPC_PRIVATE_APP_SUBNET1_CIDR_BLOCK" {
  description = "The CIDR block for the APP subnet1 in VPC"
  type        = string
  default     = "10.0.1.0/24"
}

variable "project_VPC_PRIVATE_APP_SUBNET2_CIDR_BLOCK" {
  description = "The CIDR block for the APP Subnet2 in VPC"
  type        = string
  default     = "10.0.2.0/24"
}

variable "project_VPC_PRIVATE_DB_SUBNET1_CIDR_BLOCK" {
  description = "The CIDR block for the DB subnet1 in VPC"
  type        = string
  default     = "10.0.3.0/24"
}

variable "project_VPC_PRIVATE_DB_SUBNET2_CIDR_BLOCK" {
  description = "The CIDR block for the DB subnet2 in VPC"
  type        = string
  default     = "10.0.4.0/24"
}

variable "ENVIRONMENT" {
  description = "AWS VPC Environment Name"
  type        = string
  default     = "Development"
}

