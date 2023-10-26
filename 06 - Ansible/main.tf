provider "aws" {
  region = "me-south-1"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0" # minimum version of terraform needed (optional)
    }
  }
}

resource "aws_default_vpc" "default" {
}

resource "aws_security_group" "http_server_secgroup" {
  name = "http_server_secgroup"
  # vpc_id = "vpc-2c05f545" #instead of hardcoding use the below
  vpc_id = aws_default_vpc.default.id

  ingress = [
    {
      cidr_blocks      = ["0.0.0.0/0"]
      description      = "tcp"
      from_port        = 80
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = []
      self             = false
      to_port          = 80
    },
    {
      cidr_blocks      = ["0.0.0.0/0"]
      description      = "ssh"
      from_port        = 22
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = []
      self             = false
      to_port          = 22
    }
  ]

  egress = [{
    cidr_blocks      = ["0.0.0.0/0"]
    description      = "outbound"
    from_port        = 0
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    protocol         = -1
    security_groups  = []
    self             = false
    to_port          = 0
  }]

  tags = {
    name = "http_server_secgroup"
  }

}

resource "aws_instance" "my_ec2_http_server" {
  #ami = "ami-0c68df699c2b2009a"
  count = 3
  ami             = data.aws_ami.aws-linux-2-latest.id
  key_name        = "test-ec2-creation-key"
  instance_type   = "t3.micro"
  security_groups = [aws_security_group.http_server_secgroup.id]
  #subnet_id = "subnet-4c04f425"
  subnet_id = data.aws_subnets.default_subnets.ids[2]

  
}










