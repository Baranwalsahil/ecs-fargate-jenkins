# ECS cluster for the Jenkins controller
resource "aws_ecs_cluster" "controller" {
  name = "${var.prefix}-controller"
}

# ECS cluster for the Jenkins agent
resource "aws_ecs_cluster" "agents" {
  name = "${var.prefix}-agents"
}

# ECS cluster capacity provider for the Jenkins controller cluster
resource "aws_ecs_cluster_capacity_providers" "controller" {
  cluster_name       = aws_ecs_cluster.controller.name
  capacity_providers = ["FARGATE"]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = "FARGATE"
  }
}

# ECS cluster capacity provider for the Jenkins agent cluster
resource "aws_ecs_cluster_capacity_providers" "agents" {
  cluster_name       = aws_ecs_cluster.agents.name
  capacity_providers = ["FARGATE"]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = "FARGATE"
  }
}

# task definition for the Jenkins controller
resource "aws_ecs_task_definition" "jenkins_td" {
  depends_on = [null_resource.build_and_push_image_jenkins_controller]
  family     = var.prefix
  container_definitions = templatefile(
    "${path.module}/task-definitions/jenkins.tftpl", {
      name                    = "${var.prefix}",
      image                   = aws_ecr_repository.jenkins_controller_repo.repository_url,
      cpu                     = var.jenkins_controller_cpu,
      memory                  = var.jenkins_controller_mem,
      efsVolumeName           = "${var.prefix}-efs",
      efsVolumeId             = aws_efs_file_system.efs.id,
      transmitEncryption      = true,
      containerPath           = "/var/jenkins_home",
      region                  = var.aws_region
      jenkins_controller_port = var.jenkins_controller_port
      jenkins_agent_port      = var.jenkins_agent_port
    }
  )
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.jenkins_controller_cpu
  memory                   = var.jenkins_controller_mem
  execution_role_arn       = aws_iam_role.jenkins_execution_role.arn
  task_role_arn            = aws_iam_role.jenkins_execution_role.arn

  # Setting the volume to the EFS
  volume {
    name = "${var.prefix}-efs"

    efs_volume_configuration {
      file_system_id     = aws_efs_file_system.efs.id
      root_directory     = "/"
      transit_encryption = "ENABLED"

      authorization_config {
        access_point_id = aws_efs_access_point.efs_ap.id
        iam             = "ENABLED"
      }
    }
  }
}

# ECS service for the Jenkins controller
resource "aws_ecs_service" "jenkins" {
  depends_on = [null_resource.build_and_push_image_jenkins_controller]
  name       = "jenkins"
  # The Jenkins Controller cluster
  cluster = aws_ecs_cluster.controller.id
  # The Jenkins controller task definition
  task_definition = aws_ecs_task_definition.jenkins_td.arn
  launch_type     = "FARGATE"
  enable_execute_command = true

  desired_count                      = 1
  deployment_minimum_healthy_percent = 0
  deployment_maximum_percent         = 100

  # Setting the service to run in all private subnets and attached the jenkins-controller security group
  network_configuration {
    subnets         = [aws_subnet.public_subnets.id]
    security_groups = [aws_security_group.jenkins_controller.id]
    assign_public_ip = true
  }

  # Registering the Jenkins controller private DNS created with CloudMap
  service_registries {
    registry_arn = aws_service_discovery_service.controller.arn
  }

  # Specifying the load balancer target group to put this service
  load_balancer {
    target_group_arn = aws_lb_target_group.tg.arn
    container_name   = var.prefix
    container_port   = var.jenkins_controller_port
  }
}