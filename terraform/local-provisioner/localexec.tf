resource "null_resource" "nginx-ingress-deploy" {
  provisioner "local-exec" {
    working_dir = "../scripts"
    interpreter = ["/bin/bash"]
    command     = "../scripts/nginx-ingress-deploy.sh"
  }
}
