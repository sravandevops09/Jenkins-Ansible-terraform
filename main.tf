provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "amzn_linux" {
  ami           = "ami-0fa3fe0fa7920f68e"
  instance_type = "t3.micro"
  key_name      = "jenkins-key"
  vpc_security_group_ids = ["sg-0bfa56e31afa0516d"]
  tags = {
    Name = "amz-linux"
  }
}

resource "aws_instance" "ubuntu_linux" {
  ami           = "ami-0ecb62995f68bb549"
  instance_type = "t3.micro"
  key_name      = "jenkins-key"
  vpc_security_group_ids = ["sg-0bfa56e31afa0516d"]
  tags = {
    Name = "ubuntu22"
  }
}


output "amzn_linux_public_ip" {
  value = aws_instance.amzn_linux.public_ip
}

output "ubuntu_linux_public_ip" {
  value = aws_instance.ubuntu_linux.public_ip
}
