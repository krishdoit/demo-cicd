resource "aws_vpc" "eks-vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    "Name"                                      = format("%s-%s-%s-vpc", var.project, var.cluster_name, var.environment)
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }

}


