data "aws_ami" "eks-worker" {
  filter {
    name   = "name"
    values = ["amazon-eks-node-${aws_eks_cluster.eks-cluster.version}-v*"]
  }

  most_recent = true
  owners      = ["602401143452"] # Amazon
}

locals {
  eks-node-userdata = <<USERDATA
#!/bin/bash
set -o xtrace
/etc/eks/bootstrap.sh --apiserver-endpoint '${aws_eks_cluster.eks-cluster.endpoint}' --b64-cluster-ca '${aws_eks_cluster.eks-cluster.certificate_authority[0].data}' '${var.cluster_name}'
USERDATA

}

resource "aws_launch_configuration" "eks-lc" {
  associate_public_ip_address = false
  iam_instance_profile        = aws_iam_instance_profile.eks-node-instance-profile.name
  image_id                    = data.aws_ami.eks-worker.id
  key_name                    = var.ssh_key_name
  instance_type               = "t2.medium"
  name_prefix                 = "eks-lc"
  security_groups             = [aws_security_group.eks-node-sg.id]
  user_data_base64            = base64encode(local.eks-node-userdata)

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "eks-asg" {
  desired_capacity     = 3
  launch_configuration = aws_launch_configuration.eks-lc.id
  max_size             = 3
  min_size             = 3
  name                 = "comryde-prod-eks-asg"
  vpc_zone_identifier  = var.node_subnet_ids

  tag {
    key                 = "Name"
    value               = "comryde-prod-eks-asg"
    propagate_at_launch = true
  }

  tag {
    key                 = "kubernetes.io/cluster/${var.cluster_name}"
    value               = "owned"
    propagate_at_launch = true
  }
}