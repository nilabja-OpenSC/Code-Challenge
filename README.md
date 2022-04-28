# Code-Challenge

Challenge 1:

The terraform code create a 3 tier architecture. The code devided into different modules. It has VPC module, webserver module, app server module and RDS database module.

Frontend tier has webservers which are in a auto scaling group and launched by launch template. The auto scaling group is part of target group which is backend target group of external facing load balancer.

Middle tier is consist of app servers which are in a auto scaling group and launched by launch template. The auto scaling group is part of target group which is backend target group of internal load balancer.

Backend is RDS mysql database.
