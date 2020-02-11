resource "fastly_service_v1" "fastly_seedaware_web" {
  name = "seedaware-web"

  domain {
    name    = "www.seedaware.com"
    comment = "terraform"
  }

  backend {
    address     = aws_instance.webserver.public_ip
    name        = "ec2-instance"
    port        = 80
    healthcheck = "ec2-healthcheck"
    max_conn    = 500
  }

  backend {
    address       = "terraform.seedaware.com"
    name          = "docker"
    port          = 80
    healthcheck   = "docker-healthcheck"
    override_host = "terraform.seedaware.com"
    max_conn      = 500
  }

  healthcheck {
    name   = "ec2-healthcheck"
    host   = aws_instance.webserver.public_ip
    path   = "/"
    method = "GET"
  }

  healthcheck {
    name   = "docker-healthcheck"
    host   = "terraform.seedaware.com"
    path   = "/"
    method = "GET"
  }

  cache_setting {
    name   = "no-cache"
    action = "pass"
  }

  force_destroy = true
}
