# Variable provider

variable "region" {
  description     = "aws region"
  type            = string
  default         = "eu-west-2"
}



# RDS variables

variable "mysql_db_identifier" {
  description     = "Identifier utilised to describe the outlined RDS MySQL database"
  type            = string
  default         = "db-ecommerce"
}

variable "mysql_allocated_storage" {
  description     = "Amount of storage (described in gibibytes) allocated to the MySQL instance"
  type            = number
  default         = 20
}

variable "mysql_engine_version" {
  description     = "Version number of the MySQL database engine to use"
  type            = string
  default         = "5.7"
}

variable "mysql_instance_class" {
  description     = "Instance class of the RDS MySQL instance"
  type            = string
  default         = "db.t2.micro"
}

variable "mysql_username" {
  description     = "Username utlised to provison the MySQL database"
  type            = string
  default         = "admin"
}

variable "mysql_password" {
  description     = "Password utlised for the outlined MySQL database"
  type            = string
  default         = "123admin&"
}



# Variables VPC

variable "vpc_cidr" {
  description     = "VPC cidr block"
  type            = string
  default         = "10.0.0.0/16"
}

variable "vpc_tenancy" {
  description     = "Tenancy status of instances launched into the VPC"
  type            = string
  default         = "default"
}

variable "vpc_dns" {
  description     = "Whether the DNS resolution is supported for the outlined VPC"
  type            = bool
  default         = true
}

variable "enable_dns_hostnames" {
  description     = "dns support status"
  type            = bool
  default         = true
}



# Variables public subnets  

variable "pub_sub1_cidr" {
  description     = "public subnet 1 cidr block"
  type            = string
  default         = "10.0.1.0/24"
}

variable "availability_zone_sub1" {
  description     = "public subnet 1 AZ"
  type            = string
  default         = "eu-west-2a"
}


variable "pub_sub2_cidr" {
  description     = "public subnet 2 cidr block"
  type            = string
  default         = "10.0.2.0/24"
}

variable "availability_zone_sub2" {
  description     = "public subnet 2 AZ"
  type            = string
  default         = "eu-west-2b"
}



# Variable ECR repository

variable "ECR_repository_name" {
  description     = "name of private ECR provisioned"
  type            = string
  default         = "ecr_ecs-repo"
}



# Variable IAM role for ECS Task Execution

variable "ecs_task_execution_policy_arn" {
  description     = "The ARN of the IAM policy to attach to the ECS task execution role"
  type            = string
  default         = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}



# Variable ECS Cluster

variable "ECS_cluster_name" {
  description     = "name of ECS provisioned"
  type            = string
  default         = "ecs_cluster"
}



#Variables ECS Task Definition

variable "ecs_task_family" {
  description     = "family name for the ECS task definition"
  type            = string
  default         = "ecs_task_def_family"
}

variable "ecs_task_cpu" {
  description     = "cpu units of outlined container"
  type            = string
  default         = "512"
}

variable "ecs_task_memory" {
  description     = "memory of outlined container"
  type            = string
  default         = "1024"
}

variable "ecs_execution_role_arn" {
  description     = "The ARN of the IAM role for ECS task execution"
  default         = "arn:aws:iam::169640714358:role/ecsTaskExecutionRole"
}



# Variable ALB sg

variable "alb_security_group_name" {
  description   = "Name of the ALB security group"
  type          = string
  default       = "ALB_ecs_sg"
}



# Variables ECS sg 

variable "ecs_security_group_name" {
  description    = "Name of the ECS task security group"
  type           = string
  default        = "ECS_task_sg"
}

variable "ingress_from_port" {
  description    = "The starting port for the ingress rule"
  type           = number
  default        = 80
}

variable "ingress_to_port" {
  description   = "The ending port for the ingress rule"
  type          = number
  default       = 80
}



# Variables ECS service

variable "ecs_service_name" {
  type            = string
  default         = "ECS_Service"
}

variable "ecs_task_desired_count" {
  description     = "desirable number of count"
  type            = number
  default         = 1
}

variable "ecs_task_deployment_minimum_healthy_percent" {
  description     = "minimum threshold % before deployment"
  type            = number
  default         = 50
}

variable "ecs_task_deployment_maximum_percent" {
  description    = "minimum threshold % after deployment"
  type           = number
  default        = 100
}

variable "image_name" {
  description     = "name of the Docker image used to provision this container"
  type            = string
  default         = "caddy"
}

variable "container_port" {
  description     = "port which propels, exposes and that the container listens on"
  default         = 80
  type            = number
}



# Variables Application Load Balancer 

variable "alb_name" {
  type            = string
  default         = "ALB"
}



# Variables of target group for the ECS service

variable "alb_target_group_name" {
  type            = string
  default         = "ALBtargetgroup"
}

variable "health_check_path" {
  description     = "Path which the lb utilises to perform the health check on the targets"
  type            = string
  default         = "/"
}

variable "health_check_interval" {
  description     = "Time period between health checks (in seconds)"
  type            = number
  default         = 30
}

variable "health_check_timeout" {
  description     = "Amount of time during which no response means a failed health check (in seconds)"
  type            = number
  default         = 5
}



# Variables of listener for the ECS service

variable "alb_listener_port" {
  type            = number
  description     = "Port on which the ALB listener should listen on"
  default         = 80
}
