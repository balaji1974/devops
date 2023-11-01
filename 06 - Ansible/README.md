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

### Ansible setup and running commands
```xml
Create the 3 instances of server using terrform script (check the section above)

In the ansible.cfg file add the following:
[defaults]
inventory=./ansible_hosts -> this refers to the file where the list of instances details are present
remote_user=ec2-user -> this is the remote ec2 machine user (by default created for all servers)
private_key_file=~/aws/aws_keys/test-ec2-creation-key.pem (this is the private key that we got for connecting to EC2 instances in the beginning of this tutorial)
host_key_checking=False -> we dont need any host key checking
retry_files_enabled=False -> we will not do any file retries

In the ansible_host file add the following: 
[dev]
157.175.168.64 -> the external ip address of server1
15.184.154.14 -> the external ip address of server2
15.184.133.191 -> the external ip address of server3

Next run the ping command below to check if everything is fine: 
ansible -m ping all -> this must give a SUCCESS message for all the external IP addresses
ansible all -a "whoami" -> this will run the command whoami in all the servers 
ansible all -a "uname" -> will return the operating system's uname
ansible all -a "uname -a" -> will return more details of the OS uname
ansible all -a "pwd" -> will display the present working directory of all machines
ansible all -a "python --version" -> will display the python version from all machines (will show error if not installed)


interpreter_python=auto_silent -> This in the ansible.cfg file will turn off all python warnings

For ssh into the linux server that was created use the below command:
ssh -vvv -i <aws-keyfile.pem> <aws-user>@<machine-ip-address>
eg. 
ssh -vvv -i ~/aws/aws_keys/test-ec2-creation-key.pem ec2-user@157.175.43.216
```

### Ansible host file and custom groups
```xml
(Ansible host file is also called the inventory)
In the ansible_hosts file use the following:
[dev]
dev1 ansible_host=157.175.43.216
dev2 ansible_host=16.24.24.4
qa1 ansible_host=15.185.34.92

This will name the host machine with dev1, dev2 and qa1 instead of the ip address to display

The below would group the servers in dev and qa
[dev]
dev1 ansible_host=157.175.43.216
dev2 ansible_host=16.24.24.4
[qa]
qa1 ansible_host=15.185.34.92

Now based on it we run commands on a specific group
ansible dev -a "uname -a"

We can also create virtual mixed groups like below:
[first]
dev1
qa1

Now based on it we can run commands on this virtual group
ansible first -a "uname -a"

The below will create a group from existing group
[groupofgroups:children]
dev
first

The below is a group with is a subset of dev1 until dev5 servers
[devsubset]
dev[1:5]

```

### Ansible commands
```xml
ansible --list-host all -> Will list all the machines
ansible --list-host dev -> Will list all machines in the group dev
ansible --list-host \!first -> Will list all machines not in the group first
ansible --list-host qa:dev -> Will list a combination of machines in qa and dev

```

### Intro to Playbook
```xml
(the below is called a play and it has multiple tasks)
create a file 01-ping.yaml inside the playbooks folder 
Now, the first task that will be performed automatically is [Gathering Facts] and it is added as and automatic task (first task) before all the tasks that we define. 

---
- hosts: all -> where the task must execute, this is our first play 
  tasks:
    - name: Ping All Servers -> name of the task to run 
      action: ping -> task to perform 
    - debug: msg="Hello" -> this is the 2nd task to perform 
- hosts: dev -> this is our second play 
  tasks:
    - debug: msg="Hello Dev" 

run the file created by the below command
ansible-playbook playbooks/01-ping.yaml
```

### Execute shell commands
```xml
create a file 02-shell.yaml inside the playbooks folder 
---
- hosts: qa -> Run on qa group
  tasks:
    - name: Execute Shell Commands -> name of the task
      shell: uname -> shell command to execute
      register: uname_result -> register the output of the shell command under uname_result
    - debug: msg="{{ uname_result}}" -> print the output variable uname_result
    - debug: msg="{{ uname_result.stdout }}" -> print the output variable uname_result's array stdout
    - debug: msg="{{ uname_result.stdout_lines}}" -> print the output variable uname_result's array stdout_lines

run the file created by the below command
ansible-playbook playbooks/02-shell.yaml

```

### Variables
```xml
create a file 03-variables.yaml inside the playbooks folder and copy the below: 
---
- hosts: dev
  vars_files:
    - variables.yml -> this overrides any local variable present (like the one below)
  vars:
    variable1: "PlayBookValue" -> variable definition
  tasks:
    - name: Variable Value
      debug: msg="Value is {{ variable1 }}" -> printing the variable1 

run the file created by the below command
ansible-playbook playbooks/03-variables.yaml

ansible-playbook playbooks/03-variables.yaml -e variable1=CommadlineValue -> this will override variable1 with anything that is passed as value from command line

```
### Ansible Facts (from gathering facts step)
```xml
create a file 04-ansible-facts.yaml inside the playbooks folder and copy the below: 

---
- hosts: qa
  tasks:
    - name: Kernel
      debug: msg="{{ ansible_kernel }}" -> kernal of the OS
    - name: Hostname
      debug: msg="{{ ansible_hostname }}" -> host name of the remote machine
    - name: Distribution
      debug: msg="{{ ansible_distribution }}" -> distribution name (like amazon, azure etc)
    - debug: var=ansible_architecture -> will display architecture of the host (eg. x86_64)
    - debug: var=inventory_hostname -> prints the inventory host name
    - debug: var=groups -> prints the available groups
    - debug: var=group_names -> prints all the current group names where the host is present 
    - debug: var=hostvars -> prints all the information of all the servers

run the file created by the below command
ansible-playbook playbooks/04-ansible-facts.yaml

ansible qa -m setup -> this will display all the facts that are gathered 

```

### Installing Apache and adding HTML file to it
```xml
create a file 05-install-apache.yaml inside the playbooks folder and copy the below: 

---
- hosts: dev -> group where we need to install 
  become: true -> this is equivalant to sudo (so we become root user for installation)
  tasks:
    - yum: ->this is the task 
        name:
          - httpd -> name of the task
        state: present 
    - service: name=httpd state=started enabled=yes -> we want to run this task as a service
    - raw: "echo Welcome to MyWorld | sudo tee /var/www/html/index.html" -> create html and store it inside the apache folder

run the file created by the below command
ansible-playbook playbooks/05-install-apache.yaml

Check if everything went well by opening the browser and running:
http://<ip_address>

```

### Create and execute multiple playbooks
```xml
create file 06-playbooks.yaml inside the playbooks folder and copy the below into it: 

- import_playbook: 01-ping.yaml
- import_playbook: 02-shell.yaml
- import_playbook: 03-variables.yaml

run the file created by the below command
ansible-playbook playbooks/06-playbooks.yaml

ansible-playbook playbooks/06-playbooks.yaml --list-tasks -> This will list the tasks of all the playbooks
ansible-playbook playbooks/06-playbooks.yaml --list-hosts -> This will list the host of all the playbooks
ansible-playbook -l qa playbooks/01-ping.yaml -> This will list the host from a playbook only on a particular group (in our case qa)
ansible-playbook playbooks/06-playbooks.yaml --list-tags -> This will list the tags on all the playbooks

```

### Handling loops and conditions
```xml

```

### 
```xml

```


### References:
```xml
https://www.udemy.com/course/devops-with-docker-kubernetes-and-azure-devops

```
