resource "aws_instance" "public_instance" {
  ami           = var.ami
  instance_type = var.instance_type

  vpc_security_group_ids = [aws_security_group.my_security_group.id]

  user_data = <<-EOF
              #!/bin/bash
              # Install updates
              sudo apt update

              # Install JDK
              sudo apt install openjdk-11-jdk

              # Install Node.js
              sudo apt install nodejs
              sudo apt install npm

              # Install Jenkins
              sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \https://pkg.jenkins.io/debian/jenkins.io-2023.key
              echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \https://pkg.jenkins.io/debian binary/ | sudo tee \/etc/apt/sources.list.d/jenkins.list > /dev/null
              sudo apt-get install jenkins
              sudo systemctl start jenkins.service

              # Additional setup to allow Jenkins to run Docker
              sudo apt install docker.io
              sudo systemctl start docker
              sudo systemctl enable docker
              sudo usermod -aG docker jenkins
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
