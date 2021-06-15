variable "aws_region" {
  description = "AWS Region the EKS cluster to be launched"
  default     = "us-east-1"
}


variable "cluster_name" {
  description = "Name of the eks cluster"
  default     = "srvn-eks-cluster"
  type        = string
}


variable "environment" {
  description = "Name of the environment the EKS cluster is being launched in"
  default     = "production"
}


variable "project" {
  description = "Name of the project or organization"
  default     = "srvn"
}

variable "vpc_id" {
  description = "VPC ID"
  default     = ""

}

variable "master_subnet_ids" {
  description = "Kubernetes Cluster subnet ids"
  default     = []
  type        = list(string)
}

variable "provisioner_sg_id" {
  description = "provisioner sg id to allow traffic to workder nodes"
  default     = ""
  type        = string
}



variable "node_subnet_ids" {
  description = "Node subnet ids"
  default     = []
  type        = list(string)
}


variable "workstation_cidr" {
  description = "Workstation CIDR to access EKS Cluster"
  default     = ""
}

variable "ssh_key_name" {
  description = "ssh key pair to connect to provisioning server and eks worker nodes"
  default     = "srvn-ssh-key"
}
