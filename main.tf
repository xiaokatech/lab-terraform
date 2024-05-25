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

# 1. Create a VPC
resource "aws_vpc" "prod-vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "lab-terraform"
  }
}

# 2. Create an Internet Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.prod-vpc.id

  tags = {
    Name = "lab-terraform"
  }
}

# 3. Create a Route Table
resource "aws_route_table" "prod-route-table" {
  vpc_id = aws_vpc.prod-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  route {
    ipv6_cidr_block        = "::/0"
    egress_only_gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "lab-terraform"
  }
}

# 4. Create a Subnet
resource "aws_subnet" "subnet-1" {
  vpc_id            = aws_vpc.prod-vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "lab-terraform"
  }
}


# 5. Associate subnet with Route Table
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.subnet-1.id
  route_table_id = aws_route_table.prod-route-table.id
}

# 6. Create Security Group to allow port 20, 80 and 443
resource "aws_security_group" "allow_web" {
  name        = "allow_web"
  description = "Allow web inbound traffic"
  vpc_id      = aws_vpc.prod-vpc.id

  ingress {
    description = "HTTPS traffic"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP traffic"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "lab-terraform"
  }
}

# 7. Create a network interface with an ip in the subnet that was created in step 4
# 8. Assign an elastic IP to the network interface created in step 7
# 9. Create a ubuntu server and install/enable apache2

