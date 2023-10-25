// declarative pipeline
pipeline {
	// agent { docker { image 'maven:3.6.3' } }
	agent { docker { image 'node:21.0' } }
	stages {
		stage('Build') {
			steps {
				//sh 'mvn --version'
				sh 'node --version'
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