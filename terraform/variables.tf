variable "aws_region" {
  description = "AWS region to deploy resources in"
  type        = string
  default     = "ap-south-1"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "availability_zone" {
  description = "Availability zone for the public subnet"
  type        = string
  default     = "ap-south-1a"
}

variable "project_name" {
  description = "Name prefix used to tag all resources"
  type        = string
  default     = "terraform-aws-demo"
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance (default: Amazon Linux 2023 in ap-south-1 - CHANGE if using a different region)"
  type        = string
  default     = "ami-0f5ee92e2d63afc18"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "allowed_ssh_cidr" {
  description = "CIDR block allowed to SSH into the instance. Restrict this to your own IP (e.g. 1.2.3.4/32) instead of 0.0.0.0/0 for real use."
  type        = string
  default     = "0.0.0.0/0"
}
