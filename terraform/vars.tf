variable "aws_region" {
  description = "AWS Region the EKS cluster to be launched"
  default     = "us-east-1"
}

variable "create" {
  default = "true"
}

variable "environment" {
  description = "Name of the environment the EKS cluster is being launched in"
  default     = "production"
}


variable "project" {
  description = "Name of the project or organization"
  default     = "comryde"
}

variable "cluster_name" {
  description = "Name of the EKS Cluster"
  default     = "comryde-eks-cluster"
}

variable "vpc_cidr" {
  description = "VPC CIDR Range to setup the EKS Cluster"
  default     = "10.0.0.0/16"
}

variable "public_cidr_master" {
  description = "VPC CIDR blocks for vault subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "private_cidr_node" {
  description = "VPC CIDR blocks for consul subnets"
  type        = list(string)
  default     = ["10.0.11.0/24", "10.0.12.0/24", "10.0.13.0/24"]
}


variable "workstation_cidr" {
  description = "Workstation CIDR to access EKS Cluster"
  default     = "10.0.4.0/24"
}

variable "provisioner_sg_id" {
  description = "provisioner sg id to allow traffic to workder nodes"
  default     = []
  type        = list(string)
}

variable "terraform_version" {
  description = "terraform version to install on provisioning server"
  default     = "0.14.7"
}

variable "kubectl_version" {
  description = "kubectl version to install on provisioning server"
  default     = "v1.20.4"
}

variable "helm_version" {
  description = "helm version to install on provisioning server"
  default     = "3"
}

variable "ssh_key_name" {
  description = "ssh key pair to connect to provisioning server and eks worker nodes"
  default     = "comryde-key-ssh"
}


variable "ssh_pub_key" {
  description = "ssh pub key"
  default     = "comryde-ssh-key.pub"
}



