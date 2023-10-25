# Jenkins

### Continous Integration
```xml
Code Commit -> Unit Tests -> Code Quality -> Package -> Integration Test

```



### Install Jenkins
```xml

Run docker first 

Search for Jenkins docker installation
https://www.jenkins.io/doc/book/installing/docker/ and go the page and follow the instructions.
Run the below command: 
docker network create jenkins

Docker Image: (the below command will pull docker dind -> (to be used by Jenkins) and run it in the background)
docker run --name jenkins-docker --rm --detach \
  --privileged --network jenkins --network-alias docker \
  --env DOCKER_TLS_CERTDIR=/certs \
  --volume jenkins-docker-certs:/certs/client \
  --volume jenkins-data:/var/jenkins_home \
  --publish 2376:2376 \
  docker:dind --storage-driver overlay2


Create a docker file with the following contents. This will create a customized Jenkins image to run docker.
FROM jenkins/jenkins:2.414.3-jdk17
USER root
RUN apt-get update && apt-get install -y lsb-release
RUN curl -fsSLo /usr/share/keyrings/docker-archive-keyring.asc \
  https://download.docker.com/linux/debian/gpg
RUN echo "deb [arch=$(dpkg --print-architecture) \
  signed-by=/usr/share/keyrings/docker-archive-keyring.asc] \
  https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list
RUN apt-get update && apt-get install -y docker-ce-cli
USER jenkins
RUN jenkins-plugin-cli --plugins "blueocean docker-workflow"

Build the customized jenkins image from the docker file that was created above.
docker build -t myjenkins-blueocean:2.414.3-1 .

myjenkins-blueocean -> This image is now created.

Run this image with the below command: (change the jenkins running port to 8090 from the default 8080)
docker run --name jenkins-blueocean --restart=on-failure --detach \
  --network jenkins --env DOCKER_HOST=tcp://docker:2376 \
  --env DOCKER_CERT_PATH=/certs/client --env DOCKER_TLS_VERIFY=1 \
  --publish 8090:8080 --publish 50000:50000 \
  --volume jenkins-data:/var/jenkins_home \
  --volume jenkins-docker-certs:/certs/client:ro \
  myjenkins-blueocean:2.414.3-1

Run the below in your browser: 
http://localhost:8080 

This will ask for password to install plugins. Give the password that is displayed on the console during jenkins-blueocean  startup.(This can be found in the logs of the docker desktop console)  
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
	Add Maven -> Name: JenkinsMaven -> Install automatically (ticked) -> Save 
	Add Docker -> Docker: JenkinsDocker -> Install automatically (ticked) -> Download from docker.com -> Docker version: latest -> Save  

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
For declarative pipeline in JenkinsFile use the following:
// declarative pipeline
pipeline {
	agent any 
	stages {
		stage('Build') {
			steps {
				echo "Build"
			}
		}
		stage('Test') {
			steps {
				echo "Test"
			}
		}
		stage('Integeration') {
			steps {
				echo "Integeration Test"
			}
		}
	}
	post {
		always {
			echo "I have completed"
		}
		success {
			echo "I run when successful"
		}
		failure {
			echo "I run when I failed"
		}
	}
}

-> where pipeline, agent, stages, stage and steps are mandatory 
-> when post is added it is executed once the pipeline execution completes
	always -> run everytime after pipeline completes
	success -> run only if the pipeline is successful
	failure -> run only if the pipeline has failure
```

### Docker images as pipeline images 
```xml
For this to work the jenkins-docker along with jenkins-blueocean created in beginning of this tutorial must be running
// declarative pipeline
pipeline {
	agent { docker { image 'maven:3.6.3' } }
	//agent { docker { image 'node:21.0' } }
	stages {
		stage('Build') {
			steps {
				sh 'mvn --version'
				//sh 'node --version'
				echo "Build"
			}
		}
		stage('Test') {
			steps {
				echo "Test"
			}
		}
		stage('Integeration') {
			steps {
				echo "Integeration Test"
			}
		}
	}
	post {
		always {
			echo "I have completed"
		}
		success {
			echo "I run when successful"
		}
		failure {
			echo "I run when I failed"
		}
	}
}

-> This will pull the docker image (maven), run it and we can excute commands (mvn --version) against the run image

```

### Pipeline syntax & Environment Variables
```xml
Select your pipeline -> Pipeline Syntax ->  You can generate sample scripts here for no. of Jenkins processes
Select your pipeline -> Pipeline Syntax ->  Global Variable Reference -> Here you will have lots of global variables for your reference 
Eg. $PATH, $env.BUILD_NUMBER, $env.BUILD_ID etc

pipeline {
	agent any
	stages {
		stage('Build') {
			steps {
				echo "Build"
				echo "Path - $PATH"
				echo "Build Number - $env.BUILD_NUMBER"
				echo "Build ID - $env.BUILD_ID"
				echo "Job Name - $env.JOB_NAME"
				echo "Build Tag - $env.BUILD_TAG"
				echo "Build URL - $env.BUILD_URL"
			}
		}
		stage('Test') {
			steps {
				echo "Test"
			}
		}
		stage('Integeration') {
			steps {
				echo "Integeration Test"
			}
		}
	}
	post {
		always {
			echo "I have completed"
		}
		success {
			echo "I run when successful"
		}
		failure {
			echo "I run when I failed"
		}
	}
}
```

### Using the Maven & Docker that was added in our initial step
```xml
In our initial step we had added the below:
Manage Jenkins -> Tools ->  Maven installation -> 
	Add Maven -> Name: JenkinsMaven -> Install automatically (ticked) -> Save 
	Add Docker -> Docker: JenkinsDocker -> Install automatically (ticked) -> Download from docker.com -> Docker version: latest -> Save 

To use them:
pipeline {
	agent any
	environment {
		dockerHome= tool 'JenkinsDocker'
		mavenHome=tool 'JenkinsMaven'
		PATH="$dockerHome/bin:$mavenHome/bin:$PATH"
	}
	stages {
		stage('Build') {
			steps {
				sh 'mvn --version'
				sh 'docker version'
				echo "Build"
				echo "Path : - $PATH"
				echo "Build Number - $env.BUILD_NUMBER"
				echo "Build ID - $env.BUILD_ID"
				echo "Job Name - $env.JOB_NAME"
				echo "Build Tag - $env.BUILD_TAG"
				echo "Build URL - $env.BUILD_URL"
			}
		}
		stage('Test') {
			steps {
				echo "Test"
			}
		}
		stage('Integeration') {
			steps {
				echo "Integeration Test"
			}
		}
	}
	post {
		always {
			echo "I have completed"
		}
		success {
			echo "I run when successful"
		}
		failure {
			echo "I run when I failed"
		}
	}
}

```

### Running Unit and Integration Test
```xml
For integration testing we will add cucumber testing later 
Refer from the URL: 
https://www.baeldung.com/cucumber-spring-integration
and adding failsafe plugin from here: 
https://www.baeldung.com/maven-failsafe-plugin

# This part only covers unit testing
pipeline {
	agent any
	environment {
		dockerHome= tool 'JenkinsDocker'
		mavenHome=tool 'JenkinsMaven'
		PATH="$dockerHome/bin:$mavenHome/bin:$PATH"
	}
	stages {
		stage('Checkout') {
			steps {
				sh 'mvn --version'
				sh 'docker version'
				echo "Build"
				echo "Path : - $PATH"
				echo "Build Number - $env.BUILD_NUMBER"
				echo "Build ID - $env.BUILD_ID"
				echo "Job Name - $env.JOB_NAME"
				echo "Build Tag - $env.BUILD_TAG"
				echo "Build URL - $env.BUILD_URL"
			}
		}
		stage('Build') {
			steps {
				sh 'mvn clean compile'
				
			}
		}
		stage('Test') {
			steps {
				sh 'mvn test'
			}
		}
		stage('Integeration') {
			steps {
				echo "Integeration Test"
				echo "Add cucumber integration test later"
			}
		}
	}
	post {
		always {
			echo "I have completed"
		}
		success {
			echo "I run when successful"
		}
		failure {
			echo "I run when I failed"
		}
	}
}
```



### 
```xml

```

### References:
```xml
https://www.udemy.com/course/devops-with-docker-kubernetes-and-azure-devops
https://www.jenkins.io/
```
