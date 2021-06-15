resource "aws_subnet" "k8s-master-public-subnet" {
  count                   = var.create ? length(var.public_cidr_master) : 0
  vpc_id                  = aws_vpc.eks-vpc.id
  availability_zone       = element(data.aws_availability_zones.available.names, count.index)
  cidr_block              = element(var.public_cidr_master, count.index)
  map_public_ip_on_launch = false

  tags = {
    "Name" = format("%s-%s-%s-public-subnet-%d", var.project, var.cluster_name, var.environment, count.index + 1)
  }
}

resource "aws_route_table" "master-route-table" {
  count  = var.create ? length(var.public_cidr_master) : 0
  vpc_id = aws_vpc.eks-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    "Name" = format("%s-%s-k8s-master-routetable-%d", var.project, var.environment, count.index + 1)
  }
}

resource "aws_route_table_association" "master-route-table-association" {
  count = var.create ? length(var.public_cidr_master) : 0

  subnet_id      = element(aws_subnet.k8s-master-public-subnet.*.id, count.index)
  route_table_id = element(aws_route_table.master-route-table.*.id, count.index)
}
