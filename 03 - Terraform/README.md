# Terraform

```xml
Create a group with AdministratorAccess policy and assign this group to a user with AWS access type Programmatic Access and AWS Management Console Access (real scenario will be a more restricted access). 

An Access Key ID &  Secret access key is created with the user which has to be stored safely. 

Download terraform and install it on the PC and make this available from anywhere by adding it to the path variable. 

Check the version:
terraform version 

Next run the command 
terraform init 
(This is needed by terraform for every new project so that it can download all the dependencies) 

Create a file called main.tf and add the following commands to it: 

provider "aws"{
    region="us-east-1"
}
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

Now save and execute this file with the following command: 
terraform init -> This downloads and initializes the plugins from aws (given as part of provider in the file) needed for further execution by the program

Amazon Simple Storage Service (Amazon S3) 
Amazon Elastic Compute Cloud (Amazon EC2) 

To run terraform file we need to first setup 2 environmental variables: 
export AWS_ACCESS_KEY_ID=<hidden>
export AWS_SECRET_ACCESS_KEY=<hidden>


Next in our main.tf file add the following (comments have the : 

# plan - execute 
# first parameter to resource - type of the resource prefixed with the cloud provider name
# second parameter to resource - internal terraform name given for our bucket
resource "aws_s3_bucket" "my_s3_bucket" {
   # this is the bucket's globally unique name in AWS, note: underscore is invalid in bucket name
    bucket = "my-s3-bucket-balaji-test-001"
}
 
Next run the command 
terraform plan

This will not do anything but will show us the execution plan in the console

Next run the command 
terraform apply

This will execute the file and create the S3 bucket in Amazon S3

Next add the following:
# this will enable versioning on the resource created
    versioning {
        enabled = true
    }

Terraform state management works by comparing the following: Desired state - Known state - Actual state

Next run the command 
terraform console
(This will open up the console of terraform) 

Next add the following: 
# to output value of a variable 
# output "my_s3_bucket_versioning" is the name of the output 
# value = is the value of the variable for which we need the output 
output "my_s3_bucket_versioning" {
  value = aws_s3_bucket.my_s3_bucket.versioning[0].enabled
}

Next run the command 
terraform apply -refresh=false
(this will not apply the current state with the cloud state and will check only the local copy for changes) 

Next run the command 
terraform plan -out iam.tfplan
(this will output the plan to the file name ‘iam.tfplan’)

Now we can use this plan to apply 
terraform apply "iam.tfplan"

Next add the following:
resource "aws_iam_user" "my_iam_user" {
  name = "my_iam_user_test"
}
This will create an unique user in terraform with a name ‘my_iam_user_test’

Next run the command 
terraform destroy
(this will remove all the resources that we had created so far, good practise is to destroy resources that we do not need to avoid billing as we can always create it later when we need it) 

# Create multiple users at the same time 
resource "aws_iam_user" "my_iam_users" {
    count = 2
    name = "my_iam_users_${count.index}"
}

terraform validate -> This will validate the .tf files
terraform fmt -> This will format the .tf files
terraform state -> Will show the current state file 

Next add a variable: 
variable "my_iam_users_variable" {
  default = "my_iam_users"
}

And we can use it with the following syntax:
name = "${var.my_iam_users_variable}”

Add a list:
variable "names" {
  default = ["bala", "havisha", "haasya", "krithika"]
}

And use it: 
resource "aws_iam_user" "my_iam_users" {
  count = length(var.names)
  name  = var.names[count.index]
}

Another way to iterate a list is by converting it to a set:
resource "aws_iam_user" "my_iam_users" {
   for_each=toset(var.names)  
   name=each.value  
}
Here the index for the resource is the name of the user itself instead of number based index in the previous way where we used var.names[count.index]

Add a map: 
variable "users" {
  default = {
    bala: "India", 
    havisha: "Netherlands",
    haasya: "UK", 
    krithika: "US"
  }
}

And use it: 
resource "aws_iam_user" "my_iam_users" {
  for_each= var.users  
  name=each.key
  tags={
    country: each.value
  }  
}

Add a map of maps: 
variable "users" {
  default = {
    bala: {country: "India", department: "IT"}, 
    havisha: {country:"Netherlands", department: "HR"},
    haasya: {country:"UK", department: "SupplyChain"}, 
    krithika: {country:"US", department: "Finance"}
  }
}

And use it: 
resource "aws_iam_user" "my_iam_users" {
  for_each= var.users  
  name=each.key
  tags={
    country: each.value.country
    department: each.value.department
  }  
}

EC2 Instances: 
Region: me-south-1 (N Virginia) 
Amazon Machine Image: ami-0aeeebd8d2ab47354
Instance Type: t2.micro
VPC : vpc-6e76e613

Create a new security group: 
resource "aws_security_group" "http_server_sg" {
  name   = "http_server_sg"
  vpc_id = "vpc-6e76e613"

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

Next create a default key-pair in “aws / ec2 / network & security / key pairs” and get it downloaded. Change permission by setting chmod 400 for this file and move it to a secure location on your PC. This will be used to create the EC2 instances. 

Now Create a new EC2 instance: 
resource "aws_instance" "my_ec2_http_server" {
  ami = "ami-0aeeebd8d2ab47354"
  key_name = "my-default-ec2-keypair"
  instance_type = "t2.micro"
  security_groups = [aws_security_group.http_server_sg.id]
  subnet_id = "subnet-c5591be4"
}

Connect to the EC2 instance that was created: 
# create variable with the path to the key pair that was downloaded 
variable "ec2_key_pair" {
  default="~/aws/aws_keys/my-default-ec2-keypair.pem"
}
Add the following inside the resource block 
# connect to the instance 
connection {
  type= "ssh"
  host = self.public_ip
  user = "ec2-user" # default user 
  private_key=file(var.ec2_key_pair)
}

Next create a http server, start it and create index.html file under this server by creating the below block of code inside the resource block 
provisioner "remote-exec" {
    inline = [
      "sudo yum install httpd -y",  # install the http server 
      "sudo service httpd start",   # start the http server
      "echo Welcome to my virtual server at ${self.public_dns}  | sudo tee /var/www/html/index.html" # create a html file 
    ]
  }

Note: Once the resource is created the above commands will not take effect as instances are immutable. So if the resources are created already we need to destroy it first before we can add the above blocks in a single go. 

Making things dynamic (note-> apply -target was not working for me and hence I was using apply only)

To get the default vpc we can add this to our main.tf file and 
resource "aws_default_vpc" "default" {
}
then run the following command 
terraform apply -target=aws_default_vpc.default 
Next it can be used by adding the following line in our file: 
vpc_id= aws_default_vpc.default.id

To get the subnet dynamically we can add this to our main.tf file and 
data "aws_subnet_ids" "default_subnets" {
  vpc_id= aws_default_vpc.default.id
}
then run the following command 
terraform apply -target=aws_subnet_ids.default_subnets 
Next it can be used by adding the following line in our file: 
subnet_id= tolist(data.aws_subnet_ids.default_subnets.ids)[3] # where index is where our original subnet that we used in the file is present


To get the ami dynamically we can add this to our main.tf file and 
data "aws_ami" "aws-linux-2-latest" {
  most_recent = true
  owners = ["amazon"]
  filter {
    name="name"
    values =["amzn2-ami-hvm-*"]
  }
}

data "aws_ami_ids" "aws-linux-2-latest_ids" {
  owners = ["amazon"]
}
then run the following commands 
terraform apply -target=aws_ami_ids.aws-linux-2-latest_ids
terraform apply -target=aws_ami.aws-linux-2-latest
Next it can be used by adding the following line in our file: 
ami = data.aws_ami.aws-linux-2-latest.id

terraform graph 
This command will give a graph format of what is happening which can be applied in the online website https://dreampuf.github.io/GraphvizOnline to view the output

To create multiple instances of the EC2 servers: 
for_each = data.aws_subnet_ids.default_subnets.ids
subnet_id       = each.value
The above 2 lines must replace the subnet id that was present originally 

Next run 
terraform apply -target=data.aws_subnet_ids.default_subnets
to initialize the subnet ids 

And finally run the 
terraform apply


To create a load balancer:
# security group for load balancer 
resource "aws_security_group" "elb_sg" {
  name   = "elb_sg"
  
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

}

#create a load balancer resource
resource "aws_elb" "elb" {
  name = "elb"
  subnets = data.aws_subnet_ids.default_subnets.ids
  security_groups = [aws_security_group.elb_sg.id]
  instances = values(aws_instance.my_ec2_http_servers).*.id
  listener {
    instance_port = 80
    instance_protocol = "http"
    lb_port=80 
    lb_protocol="http"
  }
}

Now use terraform apply and it will give out a load balancer url which can be accessed after a few minutes. In my case it was http://elb-1724272591.us-east-1.elb.amazonaws.com/ 

This is the configuration to create DynamoDB 
#Configuration for DynamoDB
resource "aws_dynamodb_table" "my_backend_lock" {
  name = "dev_application_locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "LockID"
  attribute {
    name= "LockID"
    type="S"
  }
}

This will copy the application state information to the DynamoDB so that it is not needed for us to maintain it locally and we can delete our local copy. Also since lock is applied before writing the state information centrally, multiple users can now work on the same project safely.
terraform {
    backend "s3" {
    bucket = "my-dev-backend-state"
    # key signifies an environment, project name, application name and key name
    key = "dev/07-backend-state/users/backend-state"
    region = "us-east-1"
    dynamodb_table = "dev_application_locks"
    encrypt = true
  }
}

terraform workspace show
Will show the default workspace of the project

terraform workspace new prod-env
This will initialize the project once more and shift it to a new workspace called prod-env

If we use the same project to create the user again after the moving to a new workspace the user creation would fail since it is still using the default workspace to create the user. Hence the resource for creating the user can be changed now to:
resource "aws_iam_user" "my_iam_user" {
  name = "${terraform.workspace}-my_iam_user_balaji"
}

terraform workspace select default 
This will change the workspace back to the default workspace 
terraform workspace list
This would list all the workspaces that are present 

Local vs Global variables:
This is a global variable
variable "environment" {
   default ="default"
 }
This is a local variable 
locals {
  iam_user_extension="my_iam_user_balaji"
}

Using a modular approach is best in terraform and a sample is given in the project 08-modules

References:
https://www.udemy.com/course/devops-with-docker-kubernetes-and-azure-devops/
https://www.terraform.io/docs/index.html


```