provider "aws" {
  region = "us-east-1"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

resource "aws_default_vpc" "default" {
}


resource "aws_security_group" "http_server_sg" {
  name   = "http_server_sg"
  #vpc_id = "vpc-6e76e613"
  vpc_id= aws_default_vpc.default.id

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
    name = "http_server_sg"
  }

}

# Create an EC2 instance 
resource "aws_instance" "my_ec2_http_server" {
  #ami             = "ami-0aeeebd8d2ab47354"
  ami             = data.aws_ami.aws-linux-2-latest.id
  key_name        = "my-default-ec2-keypair"
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.http_server_sg.id]
  #subnet_id       = "subnet-c5591be4"
  subnet_id       = tolist(data.aws_subnet_ids.default_subnets.ids)[3]

  # make a connection to the created EC2 instance 
  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ec2-user"
    private_key = file(var.ec2_key_pair)
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum install httpd -y",                                                                   # install the http server 
      "sudo service httpd start",                                                                    # start the http server
      "echo Welcome to my virtual server Havisha and Haasya at ip ${self.public_dns}  | sudo tee /var/www/html/index.html" # create a html file 
    ]
  }
}



