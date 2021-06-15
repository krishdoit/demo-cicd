terraform {
  backend "s3" {
    bucket  = "srvn-challenge-terraform-bucket"
    key     = "terraform-server-eks-cluster/tf.state"
    region  = "us-east-1"
    encrypt = true
  }
}
