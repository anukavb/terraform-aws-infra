# Terraform AWS Infrastructure Provisioning using Infrastructure as Code (IaC)

An Infrastructure as Code (IaC) project that automates the provisioning of a complete AWS networking environment using **Terraform**. The project creates a Virtual Private Cloud (VPC), public subnet, Internet Gateway, route table, security group, SSH key pair, and an Amazon EC2 instance, enabling secure and repeatable infrastructure deployment.

---

# Overview

This project demonstrates how Terraform can be used to provision cloud infrastructure on AWS in a fully automated manner. Instead of manually creating resources through the AWS Management Console, all infrastructure components are defined declaratively in Terraform configuration files.

The infrastructure includes a custom VPC, networking resources, security configuration, automatic SSH key generation, and an EC2 instance running Ubuntu Server.

---

# Architecture

```
                Terraform
                    │
                    ▼
           AWS Infrastructure
                    │
        ┌───────────┴───────────┐
        │                       │
       VPC              Internet Gateway
        │                       │
        └───────────┬───────────┘
                    │
              Public Subnet
                    │
             Route Table
                    │
          Security Group (SSH)
                    │
            EC2 Ubuntu Instance
                    │
             SSH Remote Access
```

---

# Infrastructure Components

| Component           | Purpose                     |
| ------------------- | --------------------------- |
| Terraform           | Infrastructure provisioning |
| AWS VPC             | Isolated virtual network    |
| Public Subnet       | Hosts the EC2 instance      |
| Internet Gateway    | Internet connectivity       |
| Route Table         | Routes outbound traffic     |
| Security Group      | Allows SSH access           |
| AWS Key Pair        | Secure authentication       |
| Ubuntu EC2 Instance | Virtual machine             |

---

# Project Structure

```
.
├── README.md
├── .gitignore
└── terraform/
    ├── provider.tf
    ├── variables.tf
    ├── terraform.tfvars
    ├── terraform.tfvars.example
    ├── vpc.tf
    ├── subnet.tf
    ├── igw.tf
    ├── route_table.tf
    ├── security_group.tf
    ├── key_pair.tf
    ├── ec2.tf
    ├── outputs.tf
    └── terraform-aws-demo-key.pem (generated after apply)
```

---

# Prerequisites

Install the following software before running the project:

* Terraform
* AWS CLI
* Git
* AWS Account
* PowerShell or Command Prompt
* SSH Client

---

# AWS Configuration

Configure your AWS credentials before deploying the infrastructure.

```bash
aws configure
```

Provide:

* AWS Access Key ID
* AWS Secret Access Key
* Default Region (`ap-south-1`)
* Output Format (`json`)

Verify the configuration:

```bash
aws sts get-caller-identity
```

---

# Deployment Steps

Navigate to the Terraform directory.

```bash
cd terraform
```

Initialize Terraform.

```bash
terraform init
```

Validate the configuration.

```bash
terraform validate
```

Preview the infrastructure changes.

```bash
terraform plan
```

Deploy the infrastructure.

```bash
terraform apply
```

Type:

```
yes
```

when prompted.

Terraform will create:

* VPC
* Public Subnet
* Internet Gateway
* Route Table
* Route Table Association
* Security Group
* SSH Key Pair
* Ubuntu EC2 Instance

---

# Outputs

After deployment, Terraform displays useful outputs such as:

* Instance ID
* Public IP Address
* VPC ID
* Subnet ID
* Security Group ID
* SSH connection command

Example:

```bash
instance_public_ip = 13.xxx.xxx.xxx

ssh -i terraform-aws-demo-key.pem ubuntu@13.xxx.xxx.xxx
```

---

# Connecting to the EC2 Instance

Terraform automatically generates the private SSH key.

Connect using:

```bash
ssh -i terraform-aws-demo-key.pem ubuntu@<public-ip>
```

Example verification commands:

```bash
hostname

cat /etc/os-release

uname -a
```

---

# Security

The project currently allows SSH access from:

```
0.0.0.0/0
```

For production environments, replace this with your own public IP address:

```
YOUR_PUBLIC_IP/32
```

to improve security.

---

# Verification

After deployment, verify the infrastructure in the AWS Management Console.

Check:

* EC2 Instance
* VPC
* Public Subnet
* Internet Gateway
* Route Table
* Security Group

Also verify SSH connectivity to the EC2 instance.

---

# Destroy Infrastructure

After completing testing, remove all resources to avoid unnecessary AWS charges.

```bash
terraform destroy
```

Type:

```
yes
```

when prompted.

Terraform will delete all created AWS resources.

---

# Features

* Infrastructure as Code using Terraform
* Automated AWS resource provisioning
* Custom VPC creation
* Public subnet configuration
* Internet Gateway setup
* Route table configuration
* Security group configuration
* Automatic SSH key generation
* Ubuntu EC2 instance deployment
* Terraform outputs for quick access
* Repeatable and reproducible deployments

---

# Future Improvements

* Private subnet support
* NAT Gateway
* Multi-AZ deployment
* Auto Scaling Group
* Application Load Balancer
* Remote Terraform state using Amazon S3
* State locking with DynamoDB
* Modular Terraform architecture
* CI/CD integration using GitHub Actions or Jenkins

---

# License

This project is intended for educational purposes and demonstrates Infrastructure as Code (IaC) using Terraform and Amazon Web Services (AWS).
