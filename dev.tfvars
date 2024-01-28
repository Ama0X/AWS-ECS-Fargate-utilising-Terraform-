# environment for DEV
region                                          = "eu-west-1"
vpc_cidr                                        = "10.0.0.0/20"
pub_sub1_cidr                                   = "10.0.1.0/28"
pub_sub2_cidr                                   = "10.0.2.0/28"
availability_zone_sub1                          = "eu-west-1a"
availability_zone_sub2                          = "eu-west-1b"



ECR_repository_name                              = "dev_env_ecr-repo"
ECS_cluster_name                                 = "dev_Cluster"
ecs_task_cpu                                     = "256"
ecs_task_memory                                  = "512"
ecs_task_desired_count                           = "3"
ecs_task_deployment_minimum_healthy_percent      = "20"
ecs_task_deployment_maximum_percent              = "300"



health_check_path                        = "/custom-health-check"
health_check_interval                    = "45"
health_check_timeout                     = "10"