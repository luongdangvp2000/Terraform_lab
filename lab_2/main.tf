terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
}

provider "aws" {
  region  = "ap-southeast-1"
  access_key = var.access_key
  secret_key = var.secret_key
}

resource "aws_instance" "app_server" {
  ami           = "ami-0df7a207adb9748c7" #"ami-0b94777c7d8bfe7e3"
  instance_type = "t2.micro"
  key_name = var.key_name
  vpc_security_group_ids = [aws_security_group.demo_sg.id]

  tags = {
    Name = "AppServer"
  }

  user_data = file("userdata.tpl")

}

# Default VPC, for using directly this VPC 
resource "aws_default_vpc" "default" {}

# Security group, define rule, access port 22 for SSH, and port 80 for web
resource "aws_security_group" "demo_sg" {
  name        = "demo_sg"
  description = "allow ssh on 22 & http on port 80"
  vpc_id      = aws_default_vpc.default.id
  
  ### ingress for dns, ssh on port 22, http on port 80
  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  } 
}




