resource "tls_private_key" "for-ssh" {
  algorithm = "RSA"
}

resource "aws_key_pair" "generated_key" {
  key_name   = var.ssh_key_name
  public_key = file(var.ssh_pub_key)
}
