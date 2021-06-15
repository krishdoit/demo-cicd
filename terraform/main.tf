module "aws-vpc" {
  source      = "./modules/aws-vpc"
  vpc_cidr    = "10.0.0.0/16"
  project     = "srvn"
  environment = "prod"

  public_cidr_master      = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  private_cidr_node       = ["10.0.11.0/24", "10.0.12.0/24", "10.0.13.0/24"]
  public_cidr_provisioner = ["10.0.4.0/24"]

}


module "aws-eks" {
  source            = "./modules/aws-eks"
  vpc_id            = module.aws-vpc.aws_vpc_id
  cluster_name      = module.aws-vpc.eks_cluster_name
  master_subnet_ids = module.aws-vpc.master_subnet_ids
  node_subnet_ids   = module.aws-vpc.node_subnet_ids
  workstation_cidr  = var.workstation_cidr
  ssh_key_name      = aws_key_pair.generated_key.key_name
  provisioner_sg_id = module.provisioning-server.provisioning-server-sg-id
}


module "provisioning-server" {
  source                   = "./modules/provisioning-server"
  vpc_id                   = module.aws-vpc.aws_vpc_id
  provisioner_cluster_name = "svn-provisioning-server"
  provisioner_subnet_ids   = module.aws-vpc.provisioner_subnet_ids
  instance_type            = "t2.large"
  ssh_key_name             = aws_key_pair.generated_key.key_name
  terraform_version        = var.terraform_version
  kubectl_version          = var.kubectl_version
  helm_version             = var.helm_version
  kube_config              = module.aws-eks.kubeconfig
  config_map               = module.aws-eks.config-map-aws-auth
  workstation_cidr  = var.workstation_cidr
}


resource "aws_ebs_encryption_by_default" "ebs_encryption" {
  enabled = true
}