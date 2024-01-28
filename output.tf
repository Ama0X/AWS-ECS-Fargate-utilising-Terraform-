output "db_password" {
  value            = aws_db_instance.ecs_ecommerce_db.password
  description      = "The password for logging in to the MySQL database."
  sensitive        = true
}

output "vpc_id" {
  description      = "The ID of the created VPC"
  value            = aws_vpc.E-commerce_VPC.id
}

output "ecs_assign_public_ip" {
  description      = "This indicates whether the ECS Fargate service should be assigned a public IP"
  value            = true  
}