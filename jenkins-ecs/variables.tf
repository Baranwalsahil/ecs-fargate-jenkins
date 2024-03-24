# Prefix for naming resources
variable "prefix" {
  type        = string
  description = "A prefix to be used in naming resources for better organization."
}

# Port used by the Jenkins controller
variable "jenkins_controller_port" {
  type        = string
  description = "The port number used by the Jenkins controller for communication."
}

# Port used by Jenkins agents
variable "jenkins_agent_port" {
  type        = string
  description = "The port number used by Jenkins agents for communication with the controller."
}

# AWS region where the infrastructure will be deployed
variable "aws_region" {
  type        = string
  description = "The AWS region where the infrastructure will be deployed (e.g., us-east-1)."
}

# CPU configuration for the Jenkins controller
variable "jenkins_controller_cpu" {
  description = "The CPU configuration for the Jenkins controller, specified as needed for the environment."
}

# Memory configuration for the Jenkins controller
variable "jenkins_controller_mem" {
  description = "The memory configuration for the Jenkins controller, specified as needed for the environment."
}

variable "public_subnet_cidrs" {
  type        = string
  description = "Public Subnet CIDR values"
  default     = "10.0.1.0/24"
}

variable "public_subnet_cidrs2" {
  type        = string
  description = "Public Subnet CIDR values"
  default     = "10.0.2.0/24"
}


variable "private_subnet_cidrs" {
  type        = string
  description = "Private Subnet CIDR values"
  default     = "10.0.4.0/24"
}

variable "azs1" {
  type        = string
  description = "Availability Zones"
  default     = "us-east-1a"
}

variable "azs2" {
  type        = string
  description = "Availability Zones"
  default     = "us-east-1b"
}
