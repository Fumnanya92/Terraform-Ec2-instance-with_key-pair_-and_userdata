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
     ```hcl
     provider "aws" {
       region = "us-east-1" # Change this to your desired AWS region
     }

     resource "aws_key_pair" "example_keypair" {
       key_name   = "example-keypair"
       public_key = file("~/.ssh/id_rsa.pub") # Replace with your public key path
     }

     resource "aws_instance" "example_instance" {
       ami               = "ami-0c55b159cbfafe1f0" # Replace with your desired AMI
       instance_type     = "t2.micro"
       key_name          = aws_key_pair.example_keypair.key_name
       vpc_security_group_ids = ["sg-0123456789abcdef0"] # Replace with your security group ID

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
