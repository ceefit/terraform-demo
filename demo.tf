provider "docker" {
  host = "tcp://127.0.0.1:2376/"
}

provider "fastly" {
  api_key = var.fastly_api_key
}

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

provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

resource "aws_security_group" "allow_ssh_http" {
  name        = "allow_ssh_http"
  description = "Allow SSH/HTTP inbound traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "webserver" {
  ami           = "ami-2757f631"
  instance_type = "t2.micro"
  key_name      = "terraform"
  tags = {
    Name = "Terraform Demo"
  }
  security_groups = [
    aws_security_group.allow_ssh_http.name
  ]

  provisioner "file" {
    source      = "ec2-index.html"
    destination = "/tmp/index.html"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      host        = aws_instance.webserver.public_ip
      private_key = file("/home/chris/.ssh/terraform.pem")
    }
  }

  provisioner "remote-exec" {
    script = "bootstrap.sh"
    connection {
      type        = "ssh"
      user        = "ubuntu"
      host        = aws_instance.webserver.public_ip
      private_key = file("/home/chris/.ssh/terraform.pem")
    }
  }
}

output "ec2_instance_ip" {
  value = aws_instance.webserver.public_ip
}

output "ec2_instance_id" {
  value = aws_instance.webserver.id
}

resource "docker_container" "webserver" {
  image = docker_image.nginx.latest
  name  = "webserver"
  start = true
  ports {
    internal = 80
    external = 9999
  }
}

resource "docker_image" "nginx" {
  name = "nginx:latest"
}


