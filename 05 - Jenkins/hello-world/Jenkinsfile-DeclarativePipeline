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