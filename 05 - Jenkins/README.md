# Jenkins

### Continous Integration
```xml
Code Commit -> Unit Tests -> Code Quality -> Package -> Integration Test

```



### Install Jenkins
```xml
Docker Image:
docker pull jenkins/jenkins

install the docker image and run it on port 50000 and port 8080

Run the below in your browser: 
http://localhost:8080 

This will ask for password to install plugins. Give the password that is displayed on the console during jenkins startup. 
The plugins will be installed now (install suggested plugins)

After installation it will ask for username, pwd, name, email id etc. Fill it up and enter. 
You will now land on the main page of Jenkins


```

### Initial Setup
```xml
Do this first: 
Manage Jenkins -> Clouds -> Install a plugin -> Docker -> Install it  

1. Copy the project hello-world into a local directory and push it to GitHub repository (in my case in the URL https://github.com/balaji1974/hello-world) -> make it a public repository (just for a demo purpose)
2. Next from the browser go to http://localhost:8080 -> this is the page where Jenkins is running from the previous step
3. Manage Jenkins -> Tools ->  Maven installation -> 
	Add Maven -> Name: HelloWorldMaven -> Install automatically (ticked) -> Save 
	Add Docker -> Docker: HelloWorldDocker -> Install automatically (ticked) -> Save 

```

### Create the first pipeline
```xml
Dashboard -> Create a Job -> 
	Enter the item name: helloworld-job -> Pipeline -> Ok -> 
Build Trigger -> Poll SCM -> Schedule -> 
	* * * * * -> (this will run every minute) -> 
Pipeline -> (from dropdown) Pipeline script from SCM -> SCM: Git -> 
Repository URL: https://github.com/balaji1974/hello-world
Branch Specifier -> */main (usually it is master, so change it)
(Leave all others to default) -> Save 
Once the job is saved -> click build from the left menu 

Once the job is built succesfully -> Click on the job -> Click console output (on the left menu) -> and you can see the job log and finally you will see "Finished: SUCCESS"

Here you will also see a build and test stage. 
This is picked from the Jenkinsfile that is present in the root directory of the project. The content of this file is as below: 
node {
	stage('Build') {
		echo "Build"
	}
	stage('Test') {
		echo "Test"
	}
}

```

### Scripted pipeline 
```xml
In the Jenkinsfile add another stage like below:
node {
	stage('Build') {
		echo "Build"
	}
	stage('Test') {
		echo "Test"
	}
	stage('Integration Test') {
		echo "Integeration Test"
	}
}
Save and push to the github repo. 

Click on this pipleline -> Build
You will now see this stage in the log

In the scripted pipeline the stage blocks are optional 
node {	
	echo "Build"
	echo "Test"
	echo "Integeration Test"
}
This is the same as the above and produces the same result
```

### Declarative pipeline 
```xml


```

### 
```xml

```

### References:
```xml
https://www.udemy.com/course/devops-with-docker-kubernetes-and-azure-devops
https://www.jenkins.io/
```
