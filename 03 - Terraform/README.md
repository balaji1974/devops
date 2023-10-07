# Terraform

## Infrastructure as Code - Process
```xml
Create Template -> Provision Server -> Install Software -> Configure Software -> Deploy App 

Create Template -> tools like Packer, Amazon Machine Image (AMI)
Provision Software -> tools like Terraforms / AWS Cloud Formation 
Install and Configure Software -> tools like Ansible / Puppet / Chef 
Deploy App -> tools like Jenkins / Azure DevOps

```

## Creating AWS Account 
```xml
Create an AWS Free tier account
https://aws.amazon.com/free/

1. Create a root account 
2. Create a group called 'Developer' and add 'AdministratorAccess' to this group -> Real world senario we will follow least previlage policy 
3. Create an user 'test-user-01' 
4. Provide user access to the AWS Management Console - optional -> Tick 
5. I want to create an IAM user -> Select 
6. Custom password -> Enter your password 
7. Add the group 'Developer' to this user
8. Login with the newly created user 
9. If MFA is enabled then it will ask for MFA code 
10. Set billing alerts 

```
## Install Terraform  
```xml
1. Go to the link below
https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli

2. For MAC you can follow the below steps:
brew tap hashicorp/tap
brew install hashicorp/tap/terraform
brew update
brew upgrade hashicorp/tap/terraform
terraform --version -> This is show the latest version of terraform that was installed 
 
```

## Giving access to Terraform on AWS 
```xml

Got to IAM -> Create a new user 

Create a group with AdministratorAccess policy and assign this group to this user with the below AWS access types:
Programmatic Access

Also attach existing policy -> AdministratorAccess to this user 
(real scenario will be a more restricted access)

Once the user is created an Access Key ID and  Secret access key is created with the user which has to be downloaded and stored safely setting it up in our machine. 

To run terraform file we need to first setup 2 environmental variables in our machine (MacOS): 
export AWS_ACCESS_KEY_ID=<key got from our previous step>
export AWS_SECRET_ACCESS_KEY=<secret got from our previous step>

or on windows do the following: 
set AWS_ACCESS_KEY_ID=<key got from our previous step>
set AWS_SECRET_ACCESS_KEY=<secret got from our previous step>
```

## Terraform AWS initilization

```xml

(Check the 01-terraform-basics folder for example)

1. Download terraform and install it on the PC and make this available from anywhere by adding it to the path variable. 

2. Check the version:
terraform version 

3. All terraform files have the extension 'tf'. Create a file called main.tf 
Place the below content inside this file, save it as main.tf
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0" # minimum version of terraform needed (optional)
    }
  }
}

provider "aws"{
    region="us-east-1" # region that we need our infrastruce
}

4. Next run the command 
terraform init 
This will download all AWS required component of terraform into our working folder. 
(This is needed by terraform for every new project so that it can download all the provider dependencies - in our case AWS) 

```

## Creation of S3 bucket resources and enabling versioning

```xml
Creation of resources in Terraform is a two step process. 
a. Plan b. Execute

1. Create an S3 bucket 

Create a resouce as below:

# plan - execute 
# first parameter to resource - type of the resource prefixed with the cloud provider name
# second parameter to resource - internal terraform name given for our bucket
resource "aws_s3_bucket" "my_s3_bucket" {
    # this is the bucket's globally unique name in AWS, note: underscore is invalid in bucket name
    bucket = "my-s3-bucket-balaji-test-001"
}

2. terraform plan -> This will show the entire execution plan as to what will happen

3. terraform apply -> This will apply the changes on the S3 bucket by creating the resource with bucket name my-s3-bucket-balaji-test-001

4. Next in our main.tf file add the following   
    # this will enable versioning on the resource created
    resource "aws_s3_bucket_versioning" "versioning_example" {
      bucket = aws_s3_bucket.my_s3_bucket.id
      versioning_configuration {
        status = "Enabled"
      }
    }
terraform plan (to store the plan to a file use the command terraform plan -out my_s3_bucket.tfplan)
terraform apply -> This will create the bucket with revisioning enabled


Note: status can be one of the 3-> Enabled, Disabled or Suspended
While Enable/Suspended can be set anytime, Disabled can be set only during bucket creation time. 

```
## Terraform State Management 

```xml
Terraform state management works by comparing the following: Desired state - Known state - Actual state
Desired state -> Is what we want to achieve 
Known state -> What is kept hidden in the file called terraform.tfstate
Actual state -> What is the actual state in the cloud

Purpose for having Terraform state
https://developer.hashicorp.com/terraform/language/state/purpose
```

## Terraform Console & Output variables

```xml
terraform console
(This will open up the console of terraform) 

Type:
aws_s3_bucket.my_s3_bucket
-> This will show the complete reference configuration of this S3 bucket 

Type: (any tag that was shown from the previous excution result)
aws_s3_bucket.my_s3_bucket.versioning
-> This will show the versioning information of this S3 bucket 

Type: (since previois query result is a list we can do the following to get its content based on index)
aws_s3_bucket.my_s3_bucket.versioning[0]
-> This will show the versioning information of this S3 bucket 

Add an output variable to terraform file:
output "my_s3_bucket_versioning" {
  value=aws_s3_bucket.my_s3_bucket.versioning[0].enabled
}
-> This will output the value of aws_s3_bucket.my_s3_bucket.versioning[0].enabled into the output variable my_s3_bucket_versioning

Add anothe variable
output "my_s3_bucket_complete_details" {
  value=aws_s3_bucket.my_s3_bucket
}

To view this execute the command: (come out of the console)
terraform apply -refresh=false   
(this will compare the known state locally with the actual state on the cloud without doing the refresh so that we can output only the new variable that was introducted in the previous example)

```


## IAM USERS in terraform
```xml
Add the below to create an IAM user from terraform 

resource "aws_iam_user" "my_iam_user" {
  name = "terraform_iam_user"
}

To output this resource creation into a separate use the command:
terraform plan -out my_iam_user.tfplan

To run this file for user creation use the below command:
terraform apply "my_iam_user.tfplan"

To update an IAM user using terraform add the below command in the file:  
#Update IAM User
resource "aws_iam_user" "my_iam_user" {
  name = "terraform_iam_user_modified"
}
and run the below command to apply the changes only on the changed resource while not affecting the other parts of the file
terraform apply -target="aws_iam_user.my_iam_user"


```

## Adding tfstate files to .gitignore - **** Important ****
```xml
While committing the project to GitHub always add the tfstate files to the .gitignore, as it stores all the secrets in an unencrypted format and hence it is not advisable to push this file to the github repository 

Add the below 3 files to the project's gitignore file
*.tfstate
*.tfstate.backup
.terraform

```

## Refactoring terraform's main.tf file 
```xml
(Check the 02-terraform-refraction folder for example)
You can move outputs into a seperate file, user creation in a seperate file and leave others into the main.tf file.
Terraform concats all these files and excutes it in one go. 


```

## Terraform - Destroy resources
```xml
terraform destroy
-> this will remove all the resources that we had created so far, good practise is to destroy resources that we do not need to avoid billing as we can always create it later when we need it
```

## More Terraform basics

### Create multiple resources at the same time
```xml
(Check the 03-terraform-more-basics folder for example)

Create multiple iam users 
# plan - execute 
# Create multiple users at the same time
resource "aws_iam_user" "my_iam_users" {
    count = 2
    name = "my_iam_user_${count.index}"
}
where count will loop for 0 and 1 and two users will be created (this is Hashcorp control language)

```

### Utlilty commands for the terraform script
```xml
terraform validate -> This will validate the script 
terraform fmt -> This will format the terraform script (and align them correctly)
terraform show -> Will show the content of the current state file (terraform.tfstate)
```

### Creation of variables 
```xml
variable "my_iam_users_variable" {
  type= string 
  default = "my_iam_users"
}
-> This will create a variable name my_iam_users_variable with value my_iam_users

You can now use the variable anywhere in the terraform script file by refering it as below: 
${var.my_iam_users_variable}

The valid variable types are:
any (which is the default if not sepecified), string, number, bool, list, map, set, object, tuple 

You can set the value of the variable in environment variable like below: 
export TF_VAL_my_iam_users_variable=my_iam_users
(in this case you can omit the defult flag and the environment value will be applied for this variable or it will override the default value if it is present in the script file with the value set in the environment variable)

Another way of setting values in the variable is to use a file called terrform.tfvars and define the variable values like below in this file: 
my_iam_users_variable="my_iam_users"
terraform apply -var-file="any-name.tfvars" will override the file name terrform.tfvars (if you need)

We can also provide values from the command line itself like below:
terraform plan -refresh=false -var="my_iam_users_variable=my_iam_users"

The order of priority for the value is a below: 
first from the command line, from the variable file terrform.tfvars, from environment variable value, and finally from within the scrip file 

```

### List & Map
```xml
(Check the 04-lists-and-sets folder for example)
Add a list:
variable "names" {
  default = ["bala", "havisha", "haasya", "krithika"]
}

And use it: 
resource "aws_iam_user" "my_iam_users" {
  count = length(var.names)
  name  = var.names[count.index]
}

Functions like reverse, distint, sort can be used with collection var.names 
concat(var.name, ["dada"]) -> This will add new values to the list
contains(var.name, ["bala"]) -> Will return true or false based on the value, if it exist or not 

range(start index, end index, steps) -> eg. range(1,12,2) will list values 1, 3, 5, 7, 8 and 11 

The problem with list is that if one element is added in between, then all the subsequent elements must be removed first and added as the index changes. This is not advisable and so we need something else for storage of elements that keep changing.
To set method is the answer to this, as it uses the index key as the value itself instead of number and so even if we insert a list value inbetween, the other values will not be affected (will not be deleted and created again)

Another way to iterate a list is by converting it to a set:
resource "aws_iam_user" "my_iam_users" {
   for_each=toset(var.names)  
   name=each.value  
}
Here the index for the resource is the name of the user itself instead of number based index in the previous way where we used var.names[count.index]

(Check the 05-maps folder for example)
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

```

### Create an EC2 instance 
```xml
Step 1
From the EC2 Instances launch panel copy the following (as per your requirement): 
Region: me-south-1 - Middle East (Bahrain)
Amazon Machine Image: ami-0c68df699c2b2009a - Amazon Linux 2023 AMI 2023.2.20231002.0 x86_64 HVM kernel-6.1
Instance Type: t3.micro
VPC : vpc-2c05f545 (use default for now)


Step 2
Create a new security group: (which will allow http port - 80, ssh port - 22 and CIDR block to allow access from anywhere CIDR["0.0.0.0/0"])

resource "aws_security_group" "http_server_secgroup" {
  name   = "http_server_secgroup"
  vpc_id = "vpc-2c05f545"

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
For more functionality refer to the below link:
https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group
The newly created security group can be viewed under EC2 -> Security Groups.
Copy the security group id from here to be used in Step 4. 

Step 3
Next create a default key-pair in “aws / ec2 / network and security / key pairs” and get it downloaded. 
Move the file to a standard folder: ~/aws/aws-keys (not necessary but this is kind of standard)
Change permission by setting chmod 400 for this file 
Eg. chmod 400 <name of the file>.pem -> chmod 400 test-ec2-creation-key.pem
This will be used to create the EC2 instances. 

Step 4
Now Create a new EC2 instance: 
resource "aws_instance" "my_ec2_http_server" {
  ami = "ami-0c68df699c2b2009a"
  key_name = "test-ec2-creation-key"
  instance_type = "t3.micro"
  security_groups = [aws_security_group.http_server_secgroup.id]
  subnet_id = "subnet-4c04f425"
}
aws_security_group.http_server_secgroup.id -> Note the id in the last to denote the id field
subnet-4c04f425 -> This is the subnet created inside the VPC for me-south-1-a

Step 5
terraform apply -> This will create the instance 
```

### Connecting and running commands on EC2 instance 
```xml

Step 1
Connect to the EC2 instance that was created in the step 3 of the previous section: 
# create variable with the path to the key pair that was downloaded 
variable "ec2_key_pair" {
  default="~/aws/aws-keys/test-ec2-creation-key.pem"
}

Step 2
Add the following inside the resource block 
# connect to the instance 
connection {
  type= "ssh"
  host = self.public_ip
  user = "ec2-user" # default user that will be created automatically when an EC2 instance is created 
  private_key=file(var.ec2_key_pair)
}

Step 3
Next create a http server, start it and create index.html file under this server by creating the below block of code inside the resource block 
Add this also inside the resource block 
provisioner "remote-exec" {
    inline = [
      "sudo yum install httpd -y",  # install the http server 
      "sudo service httpd start",   # start the http server
      "echo Welcome to my virtual server at ${self.public_dns}  | sudo tee /var/www/html/index.html" # create a html file 
    ]
  }

Note: Once the resource is created the above commands will not take effect as instances are immutable. So if the resources are created already we need to destroy it first before we can add the above blocks in a single go. 
But in the newer terraform versions the instance is automatically destroyed first and is recreated. 

Step 4 
Check the server 
http://<public_ip> or http://<public_dns_of_the_server>
Eg. http://ec2-157-175-175-68.me-south-1.compute.amazonaws.com/

```

### Making things dynamic
```xml
Step 1 - Making VPC dynamic
To get the default vpc we can add this to our main.tf file  
resource "aws_default_vpc" "default" {
}
then run the following command 
terraform apply -target=aws_default_vpc.default 

Now instead of hard coding the the vpc_id we can use this default VPC id. 
resource "aws_security_group" "http_server_secgroup" {
  name   = "http_server_secgroup"
  vpc_id = aws_default_vpc.default.id
  .........all other lines remain the same.........
}
https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_vpc

Step 2 - Making subnet dynamic
To get the subnet dynamically we can add this to our main.tf file and 
data "aws_subnets" "default_subnets" {
  filter {
    name   = "vpc-id"
    values = [aws_default_vpc.default.id]
  }
}
then run the following command 
terraform apply -target=data.aws_subnets.default_subnets 

Next it can be used by adding the following line in our file: 
subnet_id = data.aws_subnets.default_subnets.ids[2] # where index is where our original subnet that we used in the file is present

Step 3 - Making AMI dynamic
To get the ami dynamically we can add this to our main.tf file. 
The value to be used can be got from the ami we have used by checking in the aws EC2 instance that was created  
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

terraform apply -target=aws_ami.aws-linux-2-latest
Next it can be used by adding the following line in our file: 
ami = data.aws_ami.aws-linux-2-latest.id

```

### Best pratices for creating terraform EC2 instance 
```xml
If the configuration changes, provision a new server, and then destroy the old server, rather than making teaks to the exisitng configuations. 

This is a best practise for modifying running instances as recommended by terraform. 
```

```xml






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