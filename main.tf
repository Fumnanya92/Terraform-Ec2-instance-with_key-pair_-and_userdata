provider "aws" {
  region = "us-west-2"  # Change this to your desired AWS region
}

resource "tls_private_key" "example" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "aws_key_pair" "example_keypair" {
  key_name   = "tfkey"
  public_key = tls_private_key.example.public_key_openssh
}

resource "local_file" "tf_key" {
  content  = tls_private_key.example.private_key_pem
  filename = "tfkey"
}

# resource "aws_key_pair" "example_keypair" {
#  key_name   = "oregon"
#  public_key = file("C:/Users/DELL/Desktop/Darey.io/id_rsa.pub")  # Adjust the path to your actual public key file


resource "aws_instance" "example_instance" {
  ami               = "ami-0d081196e3df05f4d"  # Specify the correct AMI ID for your region
  instance_type     = "t2.micro"
  key_name          = aws_key_pair.example_keypair.key_name  # Reference key_name property from the key pair resource

  tags = {
    Name = "HelloWorld"
  }

  vpc_security_group_ids = ["sg-0461448d1d56f304f"]  # Replace with your actual security group ID

  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y httpd
    systemctl start httpd
    systemctl enable httpd
    echo "<h1>Hello World from $(hostname -f)</h1>" > /var/www/html/index.html
  EOF
}

output "public_ip" {
  value = aws_instance.example_instance.public_ip
}
