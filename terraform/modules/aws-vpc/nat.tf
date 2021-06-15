#NatGatways
resource "aws_eip" "nat-elastic-ips" {
  count = var.create ? length(var.public_cidr_master) : 0
}

resource "aws_nat_gateway" "nat-gateways" {
  count         = var.create ? length(var.public_cidr_master) : 0
  allocation_id = element(aws_eip.nat-elastic-ips.*.id, count.index)
  subnet_id     = element(aws_subnet.k8s-master-public-subnet.*.id, count.index)

  tags = {
    "Name" = format("%s-%s-%s-nat-gateway-%d", var.project, var.cluster_name, var.environment, count.index + 1)
  }

  depends_on = [aws_internet_gateway.igw]
}
