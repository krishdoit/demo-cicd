resource "aws_subnet" "k8s-node-private-subnet" {
  count                   = var.create ? length(var.private_cidr_node) : 0
  vpc_id                  = aws_vpc.eks-vpc.id
  availability_zone       = element(data.aws_availability_zones.available.names, count.index)
  cidr_block              = element(var.private_cidr_node, count.index)
  map_public_ip_on_launch = false

  tags = {
    "Name" = format("%s-%s-%s-private-subnet-%d", var.project, var.cluster_name, var.environment, count.index + 1)
  }
}

resource "aws_route_table" "node-route-table" {
  count  = var.create ? length(var.private_cidr_node) : 0
  vpc_id = aws_vpc.eks-vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = element(aws_nat_gateway.nat-gateways.*.id, count.index)
  }

  tags = {
    "Name" = format("%s-%s-k8s-node-routetable-%d", var.project, var.environment, count.index + 1)
  }
}

resource "aws_route_table_association" "node-route-table-association" {
  count          = var.create ? length(var.private_cidr_node) : 0
  subnet_id      = element(aws_subnet.k8s-node-private-subnet.*.id, count.index)
  route_table_id = element(aws_route_table.node-route-table.*.id, count.index)
}

