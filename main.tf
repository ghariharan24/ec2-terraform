resource "aws_instance" "public_instance" {
  ami           = var.ami
  instance_type = var.instance_type

  user_data = <<-EOF
              #!/bin/bash
              # Install updates
              sudo apt-get update

              # Install JDK
              sudo apt-get install openjdk-11-jdk

              # Install Docker
              amazon-linux-extras install docker -y
              systemctl start docker
              systemctl enable docker
              usermod -a -G docker ec2-user

              # Install Node.js
              sudo apt-get install -y nodejs
              sudo install npm

              # Install Jenkins
              sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \https://pkg.jenkins.io/debian/jenkins.io-2023.key
              echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \https://pkg.jenkins.io/debian binary/ | sudo tee \/etc/apt/sources.list.d/jenkins.list > /dev/null
              sudo apt-get install jenkins
              systemctl start jenkins.service

              # Additional setup to allow Jenkins to run Docker
              sudo apt-get install docker-ce -y
              sudo systemctl start docker
              sudo systemctl enable docker
              sudo usermod -aG docker jenkins
              EOF

  tags = {
    Name = var.name_tag,
  }
}

output "jenkins_url" {
  value = "http://${aws_instance.jenkins_server.public_ip}:8080"
}