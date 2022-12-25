terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "eu-central-1"
#  access_key = "my-access-key"
#  secret_key = "my-secret-key"
}

# Create a VPC
resource "aws_vpc" "project1" {
  cidr_block = "10.10.0.0/18"

  tags = {
    Name = "project-vpc"
  }
}

# Create subnet
resource "aws_subnet" "main_subnet" {
  vpc_id            = aws_vpc.project1.id
  cidr_block        = "10.10.10.0/24"

  tags = {
    Name = "project-main"
  }
}

# Create security group
resource "aws_security_group" "project1_sec_group" {
  name        = "allow configuration and access"
  description = "Allow ssh for configuration and 8080 for access"
  vpc_id      = aws_vpc.main.id

  ingress {
    description      = "ssh access"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    #ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
    cidr_blocks      = ["213.109.233.0/24"]
  }

  ingress {
    description      = "http access"
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    #ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

# SSH public key
resource "aws_key_pair" "robot" {
  key_name   = "robot"
  #public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKl01HNCZCoXsxy0XB3v7xPKjQmoeZHry87APvFe7rS+ mykola.ronik@gmail.com"
}

# Create instance
resource "aws_instance" "worker1" {
  ami             = "ami-05ff5eaef6149df49"
  instance_type   = "t2.micro"
  key_name        = aws_key_pair.robot.key_name
  security_groups = aws_security_group.project1_sec_group.id

  tags = {
    Name = "project-worker1"
  }
}

output "instance_dns_name" {
  value = aws_instance.worker1.public_dns
}

output "instance_public_ip_address" {
  value = aws_instance.worker1.public_ip
}
