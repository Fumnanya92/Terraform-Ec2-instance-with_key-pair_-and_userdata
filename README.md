# Mini Project: Terraform EC2 Instance with Key Pair and User Data

## Purpose:
In this mini project, we will use Terraform to automate the launch of an EC2 instance on AWS. This will include generating a downloadable key pair and executing a user data script to install and configure Apache HTTP server.

---

## Project Tasks:

### Task 1: Terraform Configuration for EC2 Instance

1. **Create Project Directory**
   - Open a terminal and create a new directory for your Terraform project:
     ```bash
     mkdir terraform-ec2-keypair
     ```
   - Change into the project directory:
     ```bash
     cd terraform-ec2-keypair
     ```

2. **Create Terraform Configuration File**
   - Create a `main.tf` file inside the project directory:
     ```bash
     nano main.tf
     ```

3. **Terraform Code for EC2 Instance**
   - Write the following Terraform code in `main.tf`:
     ```
    # AWS provider block: Specifies the AWS region where resources will be created
provider "aws" {
  region = "us-west-2"  # Change this to your desired AWS region
}

# Resource to generate a key pair using the generated public key from the tls_private_key resource
resource "aws_key_pair" "example_keypair" {
  key_name   = "example_keypair"  # The name assigned to the key pair in AWS
  public_key = tls_private_key.example.public_key_openssh  # Public key for the EC2 instance
}

# Resource to generate a private key using TLS provider (2048-bit RSA key)
resource "tls_private_key" "example" {
  algorithm = "RSA"  # Specifies the algorithm used to generate the key
  rsa_bits  = 2048   # Specifies the number of bits for the key
}

# Resource to store the generated private key locally as a file
resource "local_file" "example_keypair" {
  content  = tls_private_key.example.private_key_pem  # The private key in PEM format
  filename = "tfkey"  # The file where the private key will be saved (can be modified as needed)
}

# EC2 instance resource definition
resource "aws_instance" "example_instance" {
  ami               = "ami-0d081196e3df05f4d"  # Specify the AMI ID for your region (Amazon Linux 2 in this example)
  instance_type     = "t2.micro"  # Instance type for the EC2 instance (free-tier eligible)
  key_name          = aws_key_pair.example_keypair.key_name  # Associates the EC2 instance with the key pair for SSH access

  tags = {
    Name = "HelloWorld"  # Tag to identify the instance
  }

  # Specifies the security group that allows inbound traffic (e.g., HTTP port 80)
  vpc_security_group_ids = ["sg-0461448d1d56f304f"]  # Replace with your actual security group ID

  # User data script: This script is run when the instance starts to install and configure Apache HTTP server
  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y httpd
    systemctl start httpd
    systemctl enable httpd
    echo "<h1>Hello World from $(hostname -f)</h1>" > /var/www/html/index.html  # Creates a custom HTML page
  EOF
}

# Output block to display the public IP address of the created EC2 instance
output "public_ip" {
  value = aws_instance.example_instance.public_ip  # Outputs the public IP for easy access
}


     ```

4. **Initialize Terraform**
   - Initialize the Terraform project:
     ```bash
     terraform init
     ```

5. **Apply Terraform Configuration**
   - Run Terraform to create the EC2 instance:
     ```bash
     terraform apply
     ```
   - Confirm the changes when prompted.

---

### Task 2: User Data Script Execution

1. **Modify User Data Script**
   - The user data script is already included in the Terraform configuration, which installs and configures Apache HTTP server on the EC2 instance.

2. **Reapply Terraform Configuration**
   - If you make any updates to the `main.tf` file, reapply the Terraform configuration:
     ```bash
     terraform apply
     ```

---

### Task 3: Accessing the Web Server

1. **Get EC2 Public IP**
   - After the EC2 instance is created, retrieve the public IP address from the Terraform output or AWS console.

2. **Access Apache Web Server**
   - Open a browser and enter the public IP address. You should see a webpage with the message:  
     **Hello World from `<hostname>`**

---

## Notes and Observations:
- The project demonstrates how to use Terraform to launch an EC2 instance with a key pair and automatically configure a web server using user data.
- Ensure the security group allows traffic on port 80 for HTTP access.

## Challenges Faced:
- If the public key path is incorrect, Terraform will throw an error during the `apply` step. Double-check the key path.
- If the web server doesn’t respond, ensure the security group settings allow inbound traffic on port 80.

---

## Conclusion:
This project automated the setup of an EC2 instance with Apache HTTP server using Terraform, showcasing how infrastructure can be provisioned as code with the added benefit of configuring services via user data scripts.
