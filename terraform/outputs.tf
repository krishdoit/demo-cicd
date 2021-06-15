output "kubeconfig" {
  value = module.aws-eks.kubeconfig
}

output "config-map-aws-auth" {
  value = module.aws-eks.config-map-aws-auth
}

output "provisioner-public-ip" {
  value = module.provisioning-server.provisioning-server-public-ip
}

output "ecr-reg-arn" {
  value = aws_ecr_repository.ecr-repo.arn
}

output "ecr-repo-url" {
  value = aws_ecr_repository.ecr-repo.repository_url
}


output "tls-cert-ingress" {
  value = tls_self_signed_cert.comryde-nginx-ingress-certificate.cert_pem
}

output "tls-key-ingress" {
value = tls_private_key.comryde-nginx-ingress.private_key_pem

}

# terraform output kubeconfig # save output in ~/.kube/config Remove the head and leading headers EOT

# Configure kubectl
# terraform output kubeconfig # save output in ~/.kube/config
# aws eks --region <region> update-kubeconfig --name terraform-eks-demo
# Configure config-map-auth-aws
# terraform output config-map-aws-auth # save output in config-map-aws-auth.yaml
# kubectl apply -f config-map-aws-auth.yaml