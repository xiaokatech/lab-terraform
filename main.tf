terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

variable "AWS_REGION" {
  type        = string
  description = "AWS access key"
}
variable "AWS_ACCESS_KEY" {
  type        = string
  description = "AWS access key"
}
variable "AWS_SECRET_KEY" {
  type        = string
  description = "AWS secret key"
}

# Configure the AWS Provider
provider "aws" {
  region     = var.AWS_REGION
  access_key = var.AWS_ACCESS_KEY
  secret_key = var.AWS_SECRET_KEY
}

# resource "aws_instance" "my-first-server" {
#   ami           = "ami-04b70fa74e45c3917"
#   instance_type = "t2.nano"

#   tags = {
#     Name = "lab-terraform"
#   }
# }

resource "aws_vpc" "first-vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "lab-terraform"
  }
}

resource "aws_subnet" "subnet-1" {
  vpc_id     = aws_vpc.first-vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "lab-terraform"
  }
}
