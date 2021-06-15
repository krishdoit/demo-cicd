data "aws_caller_identity" "current" {}

# Get the latest Amazon Linux AMI
data "aws_ami" "provisioner" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "name"
    values = ["amzn-ami-hvm-*"]
  }

}
data "aws_instances" "provisioner" {
  depends_on = [ aws_autoscaling_group.provisioner-asg ]
  instance_tags = {
    provisioning-server = "yes"
  }
}


data "template_file" "user_data_terraform" {
  template = file("${path.module}/../../templates/provisioning-server-user-data.tpl")
  vars = {
    aws_region = var.aws_region
    # aws_access_key = var.aws_access_key
    # aws_secret_key = var.aws_secret_key
    tf_ver      = var.terraform_version
    kub_ver     = var.kubectl_version
    helm_ver    = var.helm_version
    kube_config = var.kube_config
    config_map  = var.config_map
  }
}



#data "http" "srvn-workstation-ip" {
#  url = "http://ipv4.icanhazip.com"
#}

#ocals {
#  workstation-external-ip = chomp(data.http.srvn-workstation-ip.body)/32
#}


