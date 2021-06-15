resource "aws_launch_configuration" "provisioner-lc" {
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.provisioner-instance-profile.name
  image_id                    = data.aws_ami.provisioner.id
  key_name                    = var.ssh_key_name
  instance_type               = "t2.medium"
  name_prefix                 = "provisioner-lc"
  security_groups             = [aws_security_group.provisioner-sg.id]
  user_data            =  data.template_file.user_data_terraform.rendered

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "provisioner-asg" {
  desired_capacity     = 1
  launch_configuration = aws_launch_configuration.provisioner-lc.id
  max_size             = 1
  min_size             = 1
  name                 = "srvn-prod-provisioner-asg"
  vpc_zone_identifier  = var.provisioner_subnet_ids

  tag {
    key                 = "Name"
    value               = "srvn-prod-provisioner-asg"
    propagate_at_launch = true
  }
  tag {
    key                 = "provisioning-server"
    value               = "yes"
    propagate_at_launch = true
  }

}

resource "aws_security_group" "provisioner-sg" {
  name        = "provisioner-sg"
  description = "Security Group for provisioner lc"
  vpc_id      = var.vpc_id
  lifecycle {
    create_before_destroy = true
  }

  tags = {
    "Name" = var.provisioner_cluster_name
  }
}

resource "aws_security_group_rule" "allow_ssh_inbound-all" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.provisioner-sg.id
}


resource "aws_security_group_rule" "allow_https_for_github_actions" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.provisioner-sg.id
}


resource "aws_security_group_rule" "provisioner-ingress-self" {
  description              = "Allow node to communicate with each other"
  from_port                = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.provisioner-sg.id
  source_security_group_id = aws_security_group.provisioner-sg.id
  to_port                  = 65535
  type                     = "ingress"
}


resource "aws_security_group_rule" "allow_all_outbound" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.provisioner-sg.id
}
