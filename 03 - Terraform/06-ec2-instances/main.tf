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

data "aws_subnets" "default_subnets" {
  filter {
    name   = "vpc-id"
    values = [aws_default_vpc.default.id]
  }
}

resource "aws_security_group" "http_server_secgroup" {
  name   = "http_server_secgroup"
  # vpc_id = "vpc-2c05f545" #instead of hardcoding use the below
  vpc_id=aws_default_vpc.default.id

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

variable "ec2_key_pair" {
  default="~/aws/aws_keys/test-ec2-creation-key.pem"
}

data "aws_ami" "aws-linux-2-latest" {
  most_recent = true
  owners = ["amazon"]
  filter {
    name = "name"
    values = ["al2023-ami-2023.2.20231002.0-kernel-6.1*"]
  }
   
  filter {
    name = "architecture"
    values = ["x86_64"]
  }
}


resource "aws_instance" "my_ec2_http_server" {
  #ami = "ami-0c68df699c2b2009a"
  ami = data.aws_ami.aws-linux-2-latest.id
  key_name = "test-ec2-creation-key"
  instance_type = "t3.micro"
  security_groups = [aws_security_group.http_server_secgroup.id]
  #subnet_id = "subnet-4c04f425"
  subnet_id = data.aws_subnets.default_subnets.ids[2]

  connection {
    type= "ssh"
    host = self.public_ip
    user = "ec2-user" 
    private_key=file(var.ec2_key_pair)
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum install httpd -y",   
      "sudo service httpd start",   
      "echo Welcome to my virtual server at ${self.public_dns}  | sudo tee /var/www/html/index.html" # create a html file 
    ]
  }
}










