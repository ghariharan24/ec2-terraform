resource "aws_instance" "public_instance" {
  ami           = var.ami
  instance_type = var.instance_type

  vpc_security_group_ids = [aws_security_group.my_security_group.id]

  user_data = <<-EOF
              set -ex
              sudo yum update -y
              sudo amazon-linux-extras install docker -y
             sudo service docker start
             sudo usermod -a -G docker hariharan24docker
            sudo curl -L https://github.com/docker/compose/releases/download/1.25.4/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
            sudo chmod +x /usr/local/bin/docker-compose
            EOF

  tags = {
    Name = var.name_tag
  }
}

resource "aws_security_group" "my_security_group" {
  name        = "my_security_group"
  description = "Security group for my EC2 instance"

  # Inbound rules
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
  tags = {
    Name = "my_security_group"
  }
}
