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
  region = "us-east-1"
  default_tags {
    tags = {
      Terraform = true
      Project   = "Test Ansible"
    }
  }
}

# Create a VPC
resource "aws_vpc" "default-vpc" {
  cidr_block = "172.21.0.0/19" #172.21.0.0 - 172.21.31.254
  tags = {
    Name = "VPC Test"
  }
}

resource "aws_subnet" "subnet-pub-01" {
  vpc_id = aws_vpc.default-vpc.id
  cidr_block = "172.21.0.0/23" #172.21.0.0 - 172.21.1.255

  map_public_ip_on_launch = true

  tags = {
    Name = "Subnet Public 01"
  }
}

resource "aws_internet_gateway" "internet-gateway" {
  vpc_id = aws_vpc.default-vpc.id
}

resource "aws_route_table" "route-table" {
  vpc_id = aws_vpc.default-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet-gateway.id
  }
}

resource "aws_main_route_table_association" "default-route-table-association" {
  vpc_id         = aws_vpc.default-vpc.id
  route_table_id = aws_route_table.route-table.id
}
