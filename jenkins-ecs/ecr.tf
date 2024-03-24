# Jenkins controller repo
resource "aws_ecr_repository" "jenkins_controller_repo" {
  name         = "jenkins-controller"
  force_delete = true
}

# Jenkins agent repo
resource "aws_ecr_repository" "jenkins_agent_repo" {
  name         = "jenkins-agent"
  force_delete = true
}

# Grabbing the repo endpoints and setting them as local variables
locals {
  controller_repo_endpoint = split("/", aws_ecr_repository.jenkins_controller_repo.repository_url)[0]
  agent_repo_endpoint      = split("/", aws_ecr_repository.jenkins_agent_repo.repository_url)[0]
}

# Jenkins controller configuration as creating jenkins.yaml file
resource "local_file" "jenkins_config" {
  content = templatefile("${path.module}/../docker/jenkins_controller/jenkins.yaml.tftpl", {
    count                   = 1
    ecs_agent_cluster       = aws_ecs_cluster.agents.arn,
    region                  = var.aws_region,
    jenkins_controller_port = var.jenkins_controller_port
    jenkins_agent_port      = var.jenkins_agent_port,
    jenkins_agent_sg        = aws_security_group.jenkins_agents.id,
    subnets                 = aws_subnet.public_subnets.id,
    jenkins_agent_image     = aws_ecr_repository.jenkins_agent_repo.repository_url,
    jenkins_dns             = "${aws_service_discovery_service.controller.name}.${aws_service_discovery_private_dns_namespace.controller.name}",
    ecs_execution_role      = aws_iam_role.jenkins_execution_role.arn
  })
  filename = "${path.module}/../docker/jenkins_controller/jenkins.yaml"
}

# build and push the Jenkins controller image to the Jenkins controller repo
resource "null_resource" "build_and_push_image_jenkins_controller" {
  depends_on = [local_file.jenkins_config]

  provisioner "local-exec" {
    command = "bash build_and_push_image.sh controller ${var.aws_region} ${local.controller_repo_endpoint} ${path.module} ${aws_ecr_repository.jenkins_controller_repo.repository_url}"
  }
}

# build and push the Jenkins agent image to the Jenkins agent repo
resource "null_resource" "build_and_push_image_jenkins_agent" {
  provisioner "local-exec" {
    command = "bash build_and_push_image.sh agent ${var.aws_region} ${local.agent_repo_endpoint} ${path.module} ${aws_ecr_repository.jenkins_agent_repo.repository_url}"
  }
}