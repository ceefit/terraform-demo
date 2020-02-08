resource "fastly_service_v1" "fastly_seedaware_web" {
  name = "seedaware-web"

  domain {
    name    = "terraform.seedaware.com"
    comment = "terraform"
  }

  backend {
    address = aws_instance.webserver.public_ip
    name    = "ec2-instance"
    port    = 80
  }

  force_destroy = true
}
