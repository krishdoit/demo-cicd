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
  default     = "srvn"
}

variable "cluster_name" {
  description = "Name of the EKS Cluster"
  default     = "eks-cluster"
}


variable "provisioner_cluster_name" {
  description = "Name of the EKS Cluster"
  default     = "provisioner-cluster"
}


variable "vpc_cidr" {
  description = "VPC CIDR Range to setup the EKS Cluster"
  default     = "10.0.0.0/16"
}

variable "public_cidr_provisioner" {
  description = "VPC CIDR Range to setup the provisioner"
  default     = ["10.0.4.0/24"]
}

# variable "azs" {
# description = "Availability Zones"
#type        = list(string)
#default     = ["us-east-1", "us-east-2", "us-east-3"]
#}

variable "public_cidr_master" {
  description = "VPC CIDR blocks for vault subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "private_cidr_node" {
  description = "VPC CIDR blocks for consul subnets"
  type        = list(string)
  default     = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
}



