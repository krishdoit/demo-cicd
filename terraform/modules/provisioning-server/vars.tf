
variable "provisioner_cluster_name" {
  description = "The name of the terraform cluster (e.g. terraform-stage). This variable is used to namespace all resources created by this module."
  type        = string
}

variable "aws_region" {
  description = "AWS Region the EKS cluster to be launched"
  default     = "us-east-1"
}

variable "ami_id" {
  description = "The ID of the AMI to run in this cluster. Should be an AMI that had terraform installed and configured by the install-terraform module."
  type        = string
  default     = ""
}

variable "instance_type" {
  description = "The type of EC2 Instances to run for each node in the cluster (e.g. t2.micro)."
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC in which to deploy the terraform cluster"
  type        = string
}

variable "provisioner_subnet_ids" {
  description = "provisioner subnet ids"
  default     = []
  type        = list(string)
}

variable "workstation_cidr" {
  description = "Workstation CIDR to access EKS Cluster"
  default     = ""
  type        = string

}
# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------

variable "cluster_size" {
  description = "The number of nodes to have in the terraform cluster. We strongly recommended that you use either 3 or 5."
  type        = number
  default     = 1
}

variable "cluster_tag_key" {
  description = "Add a tag with this key and the value var.cluster_tag_value to each Instance in the ASG. This can be used to automatically find other terraform nodes and form a cluster."
  type        = string
  default     = "provisioning-server"
}

variable "cluster_tag_value" {
  description = "Add a tag with key var.clsuter_tag_key and this value to each Instance in the ASG. This can be used to automatically find other terraform nodes and form a cluster."
  type        = string
  default     = "Managed by Terraform"
}

variable "subnet_ids" {
  description = "The subnet IDs into which the EC2 Instances should be deployed. We recommend one subnet ID per node in the cluster_size variable. At least one of var.subnet_ids or var.availability_zones must be non-empty."
  type        = list(string)
  default     = []
}

variable "ssh_key_name" {
  description = "The name of an EC2 Key Pair that can be used to SSH to the EC2 Instances in this cluster. Set to an empty string to not associate a Key Pair."
  type        = string
  default     = null
}

variable "allowed_ssh_cidr_blocks" {
  description = "A list of CIDR-formatted IP address ranges from which the EC2 Instances will allow SSH connections"
  type        = list(string)
  default     = []
}

variable "instance_profile_path" {
  description = "Path in which to create the IAM instance profile."
  type        = string
  default     = "/"
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

variable "kube_config" {
  description = "Path in which to create the IAM instance profile."
  type        = string
  default     = ""
}

variable "config_map" {
  description = "Path in which to create the IAM instance profile."
  type        = string
  default     = ""
}
