resource "tls_private_key" "comryde-nginx-ingress" {
  algorithm = "RSA"
}

resource "tls_self_signed_cert" "comryde-nginx-ingress-certificate" {
  key_algorithm   = "RSA"
  private_key_pem = tls_private_key.comryde-nginx-ingress.private_key_pem

  subject {
    common_name  = "*.comryde.com"
    organization = "comryde, Inc"
  }

  validity_period_hours = 1440

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]
}