terraform {
  backend "s3" {
    bucket  = "comryde-challenge-terraform-bucket"
    key     = "terraform-server-local-exec/tf.state"
    region  = "us-east-1"
    encrypt = true
  }
}
