
# Create an RDS MySQL database
resource "aws_db_instance" "ecs_ecommerce_db" {
  identifier            = var.mysql_db_identifier
  allocated_storage     = var.mysql_allocated_storage
  storage_type          = "gp2"
  engine                = "mysql"
  engine_version        = var.mysql_engine_version
  instance_class        = var.mysql_instance_class
  username              = var.mysql_username
  password              = var.mysql_password  # Replace with a secure password
  parameter_group_name  = "default.mysql5.7"
  skip_final_snapshot   = true

  tags = {
    Name                = "E-commerce_db"
  }
}


# Define a VPC for ECS
resource "aws_vpc" "E-commerce_VPC" {
  cidr_block            = var.vpc_cidr
  instance_tenancy      = var.vpc_tenancy
  enable_dns_support    = var.vpc_dns
  enable_dns_hostnames  = var.enable_dns_hostnames
  
  tags = {
    Name                = "E-commerce_VPC"
  }
}


# Outline public subnet 1
resource "aws_subnet" "Prod-pub-sub1" {
  vpc_id               = aws_vpc.E-commerce_VPC.id
  cidr_block           = var.pub_sub1_cidr
  availability_zone    = var.availability_zone_sub1
  
  tags = {
    Name               = "Prod-pub-sub1"
  }
}


# Outline public subnet 2
resource "aws_subnet" "Prod-pub-sub2" {
  vpc_id               = aws_vpc.E-commerce_VPC.id
  cidr_block           = var.pub_sub2_cidr
  availability_zone    = var.availability_zone_sub2
  
  tags = {
    Name               = "Prod-pub-sub2"
  }
}

# Outline private subnet 1
resource "aws_subnet" "Prod-priv-sub1" {
  vpc_id               = aws_vpc.E-commerce_VPC.id
  cidr_block           = var.priv_sub1_cidr
  availability_zone    = var.availability_zone_sub1

  tags = {
    Name = "Prod-priv-sub1"
  }
}

# Outline private subnet 2
resource "aws_subnet" "Prod-priv-sub2" {
  vpc_id               = aws_vpc.E-commerce_VPC.id
  cidr_block           = var.priv_sub2_cidr
  availability_zone    = var.availability_zone_sub2

  tags = {
    Name = "Prod-priv-sub2"
  }
}



# Outline AWS public route table 
resource "aws_route_table" "Prod-pub-route-table" {
  vpc_id              = aws_vpc.E-commerce_VPC.id

  tags = {
    Name              = "Prod-pub-route-table"
  }
}

# Outline AWS private route table 
resource "aws_route_table" "Prod-priv-route-table" {
  vpc_id               = aws_vpc.E-commerce_VPC.id

  tags = {
    Name               = "Prod-priv-route-table"
  }
}

# Outline AWS public route association 1
resource "aws_route_table_association" "pub-route-table-association-1" {
  subnet_id             = aws_subnet.Prod-pub-sub1.id
  route_table_id        = aws_route_table.Prod-pub-route-table.id
}


# Outline AWS public route association 2
resource "aws_route_table_association" "pub-route-table-association-2" {
  subnet_id            = aws_subnet.Prod-pub-sub2.id
  route_table_id       = aws_route_table.Prod-pub-route-table.id
}

# Outline AWS private route association 1
resource "aws_route_table_association" "priv-route-table-association-1" {
  subnet_id           = aws_subnet.Prod-priv-sub1.id
  route_table_id      = aws_route_table.Prod-priv-route-table.id
}

# Outline AWS private route association 2
resource "aws_route_table_association" "priv-route-table-association-2" {
  subnet_id          = aws_subnet.Prod-priv-sub2.id
  route_table_id     = aws_route_table.Prod-priv-route-table.id
}


# Outline AWS IGW
resource "aws_internet_gateway" "Prod-igw" {
  vpc_id           = aws_vpc.E-commerce_VPC.id

  tags = {
    Name           = "Prod-igw"
  }
}


# Outline AWS route for IGW & pub route table
resource "aws_route" "Prod-igw-association" {
  route_table_id            = aws_route_table.Prod-pub-route-table.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id                = aws_internet_gateway.Prod-igw.id
}


# Create Elastic IP Address
resource "aws_eip" "Prod-eip" {
tags = {
Name               = "Prod-eip"
}
}


# Create NAT Gateway
resource "aws_nat_gateway" "Prod-Nat-gateway" {
allocation_id       = aws_eip.Prod-eip.id
subnet_id           = aws_subnet.Prod-pub-sub1.id
tags = {
Name                = "Prod-Nat-gateway"
}
}


# Outline NAT associate with priv route
resource "aws_route" "Prod-Nat-association" {
route_table_id             = aws_route_table.Prod-priv-route-table.id
gateway_id                 = aws_nat_gateway.Prod-Nat-gateway.id
destination_cidr_block     = "0.0.0.0/0"
}


 # Define an Elastic Container Registry (ECR) repository for the Docker image 
resource "aws_ecr_repository" "ECS_repository" {
  name                      = var.ECR_repository_name
  image_tag_mutability      = "MUTABLE"
}


# Define an IAM role for ECS Task Execution
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskExecutionRole"
 
 assume_role_policy = jsonencode({
    Version         = "2012-10-17",
    Statement       = [{
      Action        = "sts:AssumeRole",
      Effect        = "Allow",
      Principal     = {
        Service     = "ecs-tasks.amazonaws.com",
      },
    }],
  })
}


 # Attach the AmazonECSTaskExecutionRolePolicy to the IAM role
resource "aws_iam_role_policy_attachment" "ecs_task_execution_attachment" {
  policy_arn     = var.ecs_task_execution_policy_arn
  role           = aws_iam_role.ecs_task_execution_role.name
}


# Define an ECS Cluster
resource "aws_ecs_cluster" "ECS_Cluster" {
  name         = var.ECS_cluster_name
}


# Define an ECS Task Definition
resource "aws_ecs_task_definition" "ECS_task_def" {
  family                    = var.ecs_task_family
  network_mode              = "awsvpc"
  requires_compatibilities  = ["FARGATE"]
  cpu                       = var.ecs_task_cpu
  memory                    = var.ecs_task_memory

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }

  execution_role_arn       = var.ecs_execution_role_arn

  container_definitions = jsonencode([{
    name               = "caddy"
    image              = "public.ecr.aws/docker/library/caddy:latest"
    portMappings       = [{
      containerPort    = 80,
      hostPort         = 80,
    }]
  }])
}


# AWS ALB security group w/ ingress and egrees rule
resource "aws_security_group" "ALB_security_group" {
 name                = var.alb_security_group_name
 vpc_id              = aws_vpc.E-commerce_VPC.id
 description         = "ALB for ECS security group"

 ingress {
   from_port         = 80
   to_port           = 80
   protocol          = "tcp"
   cidr_blocks       = ["0.0.0.0/0"]
   ipv6_cidr_blocks  = ["::/0"]
 }

 ingress {
   from_port         = 80
   to_port           = 80
   protocol          = "tcp"
   cidr_blocks       = ["0.0.0.0/0"]
   ipv6_cidr_blocks  = ["::/0"]
 }

 egress {
   from_port         = 0
   to_port           = 0
   protocol          = "-1"
   cidr_blocks       = ["0.0.0.0/0"]
   ipv6_cidr_blocks  = ["::/0"]
 }
}


# Outline AWS security group w/ ingress and egrees rule for ECS task that will house the container
resource "aws_security_group" "ECS_task_security_group" {
 name               = var.ecs_security_group_name
 vpc_id             = aws_vpc.E-commerce_VPC.id
 description        = "SG for caddy image which will allow traffic from the ALB"

 ingress {
   from_port         = var.ingress_from_port
   to_port           = var.ingress_to_port
   protocol          = "tcp"
   cidr_blocks       = ["0.0.0.0/0"]
   ipv6_cidr_blocks  = ["::/0"]
 }

 egress {
   from_port          = 0
   to_port            = 0
   protocol           = "-1"
   cidr_blocks        = ["0.0.0.0/0"]
   ipv6_cidr_blocks   = ["::/0"]
 }
}


# Define an ECS service
resource "aws_ecs_service" "service" {
 name                               = var.ecs_service_name
 cluster                            = aws_ecs_cluster.ECS_Cluster.id 
 task_definition                    = aws_ecs_task_definition.ECS_task_def.arn
 desired_count                      = var.ecs_task_desired_count
 deployment_minimum_healthy_percent = var.ecs_task_deployment_minimum_healthy_percent
 deployment_maximum_percent         = var.ecs_task_deployment_maximum_percent
 launch_type                        = "FARGATE"
 scheduling_strategy                = "REPLICA"
 
 network_configuration {
   security_groups    = [aws_security_group.ALB_security_group.id]
   subnets            = [aws_subnet.Prod-pub-sub1.id, aws_subnet.Prod-pub-sub2.id]
   assign_public_ip   = true
 }
 
 load_balancer {
   target_group_arn  = aws_lb_target_group.ALBtargetgroup.arn
   container_name    = var.image_name
   container_port    = var.container_port
 }
 
 lifecycle {
   ignore_changes    = [desired_count]
 }
}


# Create an Application Load Balancer
resource "aws_lb" "application_load_balancer" {
  name                 = var.alb_name
  internal             = false
  load_balancer_type   = "application"
  security_groups      = [aws_security_group.ALB_security_group.id]
  subnets              = [aws_subnet.Prod-pub-sub1.id, aws_subnet.Prod-pub-sub2.id]
}


# Create target group for the ECS service
resource "aws_lb_target_group" "ALBtargetgroup" {
  name               = var.alb_target_group_name
  port               = var.container_port
  protocol           = "HTTP"
  target_type        = "ip"
  vpc_id             = aws_vpc.E-commerce_VPC.id

  health_check {
    path             = var.health_check_path
    interval         = var.health_check_interval
    timeout          = var.health_check_timeout
  }
}


# Associate listener for the ECS service
resource "aws_alb_listener" "http" {
  load_balancer_arn  = aws_lb.application_load_balancer.id
  port               = var.alb_listener_port
  protocol           = "HTTP"
 
  default_action {
   type = "forward"
   target_group_arn  = aws_lb_target_group.ALBtargetgroup.arn
  }
}