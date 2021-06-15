output "aws_vpc_id" {
  value = aws_vpc.eks-vpc.id
}

output "aws_vpc_cidr" {
  value = aws_vpc.eks-vpc.cidr_block
}

output "aws_azs" {
  value = data.aws_availability_zones.available
}

output "eks_cluster_name" {
  value = var.cluster_name
}


output "master_subnet_ids" {
  value = aws_subnet.k8s-master-public-subnet.*.id
}

output "node_subnet_ids" {
  value = aws_subnet.k8s-node-private-subnet.*.id
}


output "provisioner_subnet_ids" {
  value = aws_subnet.provisioner-server-public-subnet.*.id

}