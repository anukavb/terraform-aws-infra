# Terraform AWS Infrastructure Setup

Minor project demonstrating Infrastructure as Code (IaC) principles by provisioning a
basic AWS network + compute stack with Terraform: a custom VPC, a public subnet with
Internet Gateway and route table, a security group allowing SSH, and an EC2 instance
reachable over SSH using an auto-generated key pair.

![Architecture Diagram](architecture-diagram.svg)

## Architecture

```
Internet
   |
Internet Gateway
   |
Route Table (0.0.0.0/0 -> IGW)
   |
VPC (10.0.0.0/16)
  └── Public Subnet (10.0.1.0/24)
        ├── Security Group (allow inbound TCP 22)
        └── EC2 Instance (t2.micro, public IP, key-pair auth)
```

## Repository structure

```
terraform-aws-infra/
├── provider.tf                  # Terraform + AWS/TLS/local provider config
├── variables.tf                 # All configurable inputs (CIDR, AMI, instance type, etc.)
├── vpc.tf                       # Custom VPC
├── subnet.tf                    # Public subnet
├── igw.tf                       # Internet Gateway
├── route_table.tf               # Route table + association (0.0.0.0/0 -> IGW)
├── security_group.tf            # SG allowing inbound SSH (port 22)
├── key_pair.tf                  # Generates SSH key pair, registers with AWS, saves .pem
├── ec2.tf                       # EC2 instance in the public subnet
├── outputs.tf                   # VPC ID, subnet ID, public IP, ready SSH command
├── terraform.tfvars.example     # Sample variable values (copy -> terraform.tfvars)
├── .gitignore                   # Keeps state files, .pem keys, tfvars out of git
└── README.md
```

## Prerequisites

1. An AWS account with an IAM user/role that has permission to create VPC, EC2, and
   related networking resources.
2. [Terraform](https://developer.hashicorp.com/terraform/install) >= 1.3 installed locally.
3. [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
   installed and configured (`aws configure`) with your Access Key ID / Secret Access Key.
4. An SSH client (built into Linux/macOS/WSL; use PuTTY or OpenSSH-on-Windows on Windows).

## Step-by-step execution

### 1. Configure AWS credentials
```bash
aws configure
# AWS Access Key ID:     <your key>
# AWS Secret Access Key: <your secret>
# Default region name:   ap-south-1   (or your preferred region)
# Default output format: json
```

### 2. Clone/copy this repo and set variables
```bash
cd terraform-aws-infra
cp terraform.tfvars.example terraform.tfvars
```
Open `terraform.tfvars` and adjust as needed. Important:
- `ami_id` must be a valid AMI **for the region you set in `aws_region`**. The default
  in this repo is an Amazon Linux 2023 AMI for `ap-south-1`. If you use a different
  region, look up the current AMI ID in the EC2 console (Launch Instance -> AMI Catalog)
  and replace it.
- For real-world safety, set `allowed_ssh_cidr` to `YOUR_PUBLIC_IP/32` instead of
  `0.0.0.0/0`. Find your IP with `curl ifconfig.me`.

### 3. Initialize Terraform
```bash
terraform init
```
Downloads the AWS, TLS, and local providers. **Screenshot this.**

### 4. Review the execution plan
```bash
terraform plan
```
Shows exactly what will be created (VPC, subnet, IGW, route table, SG, key pair, EC2 —
9 resources). **Screenshot this.**

### 5. Apply
```bash
terraform apply
```
Type `yes` when prompted. Takes about 1-2 minutes. **Screenshot the "Apply complete!"
output** — it will show your outputs including `instance_public_ip` and `ssh_command`.

### 6. Verify in the AWS Console
Open the AWS Console → VPC and EC2 dashboards and confirm:
- The new VPC with your CIDR block
- The public subnet
- The Internet Gateway attached to the VPC
- The route table with a `0.0.0.0/0 -> igw-xxxx` route
- The security group with an inbound rule for port 22
- The running EC2 instance with a public IP

**Screenshot each of these consoles.**

### 7. Connect via SSH
Terraform already generated a private key file named
`terraform-aws-demo-key.pem` in this directory (permissions set to `0400`
automatically). Use the output SSH command directly:

```bash
terraform output ssh_command
# copy the printed command, or run manually:

chmod 400 terraform-aws-demo-key.pem
ssh -i terraform-aws-demo-key.pem ec2-user@<instance_public_ip>
```
> Username depends on the AMI: `ec2-user` for Amazon Linux, `ubuntu` for Ubuntu AMIs.

**Screenshot the successful SSH login** (showing the shell prompt on the EC2 instance).

### 8. Clean up (avoid ongoing AWS charges)
```bash
terraform destroy
```
Type `yes` to confirm. Confirm in the console that all resources were removed.
**Screenshot this too** if your report wants to show the full lifecycle.

## Notes on design choices

- **Configurable CIDR**: `vpc_cidr` and `public_subnet_cidr` are variables (not
  hardcoded), satisfying the "CIDR block configurable via variables" requirement.
- **Key pair**: generated automatically via the `tls_private_key` + `aws_key_pair`
  resources so the project is fully reproducible without manually creating a key in
  the console first — the private key is saved locally and git-ignored.
- **Security**: the SSH security group ingress CIDR is also a variable
  (`allowed_ssh_cidr`), so it's easy to lock down to a single IP instead of the world.
- **State/secrets hygiene**: `.gitignore` excludes `*.tfstate`, `*.pem`, and
  `terraform.tfvars` so no credentials or generated secrets are ever committed.

## Deliverables checklist

- [x] Terraform files (this repo)
- [ ] Screenshots (add yours to a `screenshots/` folder as you complete steps 3-8 above)
- [x] Architecture diagram (`architecture-diagram.svg`)
- [x] Project report (`PROJECT_REPORT.md`)
