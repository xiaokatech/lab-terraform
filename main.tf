terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region     = "us-east-1"
  access_key = "access_key"
  secret_key = "secret_key"
}


resource "aws_instance" "my-first-server" {
  ami           = "ami-04b70fa74e45c3917"
  instance_type = "t2.nano"

  tags = {
    Name = "lab-terraform"
  }
}
