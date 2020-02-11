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

  user_data = file("cloud-init.cfg")
}

output "ec2_instance_ip" {
  value = aws_instance.webserver.public_ip
}

output "ec2_instance_id" {
  value = aws_instance.webserver.id
}
