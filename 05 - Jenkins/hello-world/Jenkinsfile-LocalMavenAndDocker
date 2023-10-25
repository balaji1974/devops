// declarative pipeline
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