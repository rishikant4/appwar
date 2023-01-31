pipeline {
    agent any
	environment {
	PROJECT_ID = 'calm-seeker-375715'
        CLUSTER_NAME = 'gke'
        LOCATION = 'us-central1-c'
        CREDENTIALS_ID = 'My First Project'
		
	def git_branch = 'main'
	def git_url = 'https://github.com/rishikant4/appwar.git'
	
	def mvntest = 'mvn test '
	def mvnpackage = 'mvn clean install'
	
	def utest_url = 'target/surefire-reports/**/*.xml'
		
	def sonar_cred = 'sonar'
        def code_analysis = 'mvn clean install sonar:sonar'
	def dcoker_cred='docker'
		
	def nex_cred = 'nexus'
        def grp_ID = 'com.example'
        def nex_url = '15.207.222.241:8081'
        def nex_ver = 'nexus3'
        def proto = 'http'
	}
	stages {
	stage('Github Checkout') {
	steps {
	script {
	git branch: "${git_branch}", url: "${git_url}"
	echo 'Git Checkout Completed'
	}
	}
	} 
	stage('Maven Build') {
	steps {
	sh "${env.mvnpackage}"
	echo 'Maven Build Completed'
	}
	}
	stage('Unit Test & Reports Publishing') {
            steps {
                script {
                    sh "${env.mvntest}"
                    echo 'Unit Testing Completed'
                }
            }
	post {
                success {
                        junit "$utest_url"
                        jacoco()
                }
            }
}
		stage('Build Docker Image') { 
		steps {
		   sh 'whoami'
                   script {
		      myimage = docker.build("rishi236/multibranch:${env.BUILD_ID}")
                   }
                }
	   }
	   stage("Push Docker Image") {
                steps {
                   script {
                      docker.withRegistry('https://registry.hub.docker.com', 'docker') {
                      myimage.push("${env.BUILD_ID}")
                     }   
                   }
                }
            }
	   
           stage('Deploy to K8s') { 
                steps{
                   echo "Deployment started ..."
		   sh 'ls -ltr'
		   sh 'pwd'
		   sh "sed -i 's/tagversion/${env.BUILD_ID}/g' deployment.yaml"
                   step([$class: 'KubernetesEngineBuilder', 
			 projectId: env.PROJECT_ID, 
			 clusterName: env.CLUSTER_NAME,
			 location: env.LOCATION, 
			 manifestPattern: 'deployment.yaml',
			 credentialsId: env.CREDENTIALS_ID, 
			 verifyDeployments: true])
		   echo "Deployment Finished ..."
            }
	   }
    }
}
