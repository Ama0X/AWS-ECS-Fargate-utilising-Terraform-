# environment for TEST
region                                          = "eu-west-3"
vpc_cidr                                        = "10.0.0.0/17"
pub_sub1_cidr                                   = "10.0.1.0/24"
pub_sub2_cidr                                   = "10.0.2.0/24"
priv_sub1_cidr                                  = "10.0.3.0/24"
priv_sub2_cidr                                  = "10.0.4.0/24"
availability_zone_pub_sub1                      = "eu-west-3a"
availability_zone_pub_sub2                      = "eu-west-3b"
availability_zone_priv_sub1                     = "eu-west-3a"
availability_zone_priv_sub2                     = "eu-west-3b"



ECR_repository_name                              = "test_env_ecr-repo"
ECS_cluster_name                                 = "test_Cluster"
ecs_task_cpu                                     = "1024"
ecs_task_memory                                  = "2048"
ecs_task_desired_count                           = "2"
ecs_task_deployment_minimum_healthy_percent      = "30"
ecs_task_deployment_maximum_percent              = "100"
