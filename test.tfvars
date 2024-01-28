# environment for TEST
region                                          = "eu-west-3"
vpc_cidr                                        = "10.0.0.0/17"
pub_sub1_cidr                                   = "10.0.1.0/24"
pub_sub2_cidr                                   = "10.0.2.0/24"
availability_zone_sub1                          = "eu-west-3a"
availability_zone_sub2                          = "eu-west-3b"



ECR_repository_name                              = "test_env_ecr-repo"
ECS_cluster_name                                 = "test_Cluster"
ecs_task_cpu                                     = "1024"
ecs_task_memory                                  = "2048"
ecs_task_desired_count                           = "5"
ecs_task_deployment_minimum_healthy_percent      = "30"
ecs_task_deployment_maximum_percent              = "400"



health_check_path                   = "/custom-health-check"
health_check_interval               = "55"
health_check_timeout                = "15"