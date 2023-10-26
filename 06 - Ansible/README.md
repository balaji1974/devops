# Ansible 

### Infrastructure as code
```xml
While Terraform provides a mechanism to manage the status of infrastructure resources and handles the whole lifecycle of those resources, from creation to deletion, Ansible focuses on configuring and maintaining already-existing systems rather than managing the entire lifecycle.

Main functions of ansible:
Install Software
Configure Software

```
### Install ansible on MacOS
```xml
Install homebrew if not installed
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

Next install ansible
brew install ansible

Next check the version of the installed ansible
ansible --version

For other OS please follow the below link:
https://docs.ansible.com/ansible/2.9/installation_guide/intro_installation.html#


```

### Setting up the servers needed to run samples using Ansible
```xml
First create a new AWS key pair by logging into your AWS account. 
It can be created by going to the EC2 Dashboard -> Network and security -> Key Pairs
Once created download it, move it to the folder of your choice and change the access modifier as below: 
chmod 400 <key-pair-file-name.pem>

Next do the following for creating an EC2 instance.
EC2 Dashboard -> Instances -> Launch an instance -> 
Name: my-ec2-01
Quick Start: AWS
Select Free Tier eligible image
Instance type -> Free tier eligible type
Select the key-pair that was created
Create a security group, allow SSH and HTTP traffic
Finally Launch instance 

But I am following a much easier way of creating the server instances using terraform (look for the documentation in the tutorial 03-terraform)
Copy main.tf, data-providers.tf and variable.tf from the 06-ec2-instances of the 03 - Terraform folder into the current folder 
Change the content of main.tf as follows: 
Inside the resouce {} section add the line count=3 -> This will be the no. of servers that need to be created
Also remove the connection {} and  provisioner "remote-exec" {} section fully as we will use Ansible later for this configuration

Now before running the terraform commands run the following from the command prompt:
AWS_ACCESS_KEY_ID=<Your access key>
AWS_SECRET_ACCESS_KEY=<Your secret access key>

Next run the below commands:
terraform init
terraform apply

After this step 3 servers will be provisioned in the region me-south-1


terraform destroy -> Do not forget to run this step or else you might be charged for the instances that are running. Do this after you run and practise all the below cases. 

```

### 
```xml

```


### 
```xml

```


### References:
```xml
https://www.udemy.com/course/devops-with-docker-kubernetes-and-azure-devops

```
