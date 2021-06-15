#Internet Gatway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.eks-vpc.id

  tags = {
    "Name" = format("%s-%s-%s-igw", var.project, var.cluster_name, var.environment)
  }
}