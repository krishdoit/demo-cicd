output "provisioning-server-public-ip" {
  value = [ data.aws_instances.provisioner.public_ips ]
}

output "provisioning-server-sg-id" {
  value = aws_security_group.provisioner-sg.id
}
