# AWS managed policy: AmazonECSTaskExecutionRolePolicy
data "aws_iam_policy" "aws_ecs_task_execution_policy" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# IAM policy that providers Jenkins with the necessary permissions
resource "aws_iam_policy" "jenkins_policy" {
  name = "jenkins-policy"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "",
        "Effect" : "Allow",
        "Action" : [
          "ecs:ListClusters",
          "ecs:ListTaskDefinitions",
          "ecs:ListContainerInstances",
          "ecs:RunTask",
          "ecs:StopTask",
          "ecs:DescribeTasks",
          "ecs:DescribeContainerInstances",
          "ecs:DescribeTaskDefinition",
          "ecs:RegisterTaskDefinition",
          "ecs:DeregisterTaskDefinition",
          "iam:GetRole",
          "iam:PassRole",
          "elasticfilesystem:DescribeMountTargets",
          "ec2:DescribeAvailabilityZones",
          "ecs:TagResource",
          "ecs:ExecuteCommand",
          "ecs:DescribeTasks",
          "ssmmessages:CreateControlChannel",
          "ssmmessages:CreateDataChannel",
          "ssmmessages:OpenControlChannel",
          "ssmmessages:OpenDataChannel"
        ],
        "Resource" : "*"
      }
    ]
  })
}

# Jenkins Execution Role
resource "aws_iam_role" "jenkins_execution_role" {
  name = "jenkins-execution-role"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "",
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "ecs-tasks.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })

  managed_policy_arns = [
    data.aws_iam_policy.aws_ecs_task_execution_policy.arn,
    aws_iam_policy.jenkins_policy.arn
  ]
}
