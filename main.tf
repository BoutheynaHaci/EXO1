terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "eu-west-3"
}

resource "aws_vpc" "Boutheyna_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = {
    Name = "Boutheyna VPC"
  }
}

resource "aws_instance" "Boutheyna_instance1" {
  ami = "ami-05b5a865c3579bbc4"
  instance_type = "t2.micro"
  tags = {
    Name = "Boutheyna"
    Owner = "Boutheyna HACI"
  }
}
resource "aws_ec2_instance_state" "Boutheyna_instance1" {
  instance_id = aws_instance.Boutheyna_instance1.id
  state       = "stopped"
}

resource "aws_subnet" "subnet-Bouth" {
  cidr_block = "${cidrsubnet(aws_vpc.Boutheyna_vpc.cidr_block, 3, 1)}"
  vpc_id = "${aws_vpc.Boutheyna_vpc.id}"
  availability_zone = "eu-west-3a"
}

resource "aws_security_group" "Boutheyna_SG" {
name = "Boutheyna Security Group"
vpc_id = "${aws_vpc.Boutheyna_vpc.id}"
ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
from_port = 22
    to_port = 22
    protocol = "tcp"
  }
// Terraform removes the default rule
  egress {
   from_port = 0
   to_port = 0
   protocol = "-1"
   cidr_blocks = ["0.0.0.0/0"]
 }
}
