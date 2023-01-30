pipeline {
    agent any
	environment {
	PROJECT_ID = 'calm-seeker-375715'
        CLUSTER_NAME = 'staging'
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
		stage('Docker build'){
        steps{
            script{
                sh 'docker build -t rishi236/spring:0.1 . '
            }
        }
       }
       stage('Docker login and push'){
        steps{
            withCredentials([string(credentialsId: 'docker_creds', variable: 'docker')]) {
            sh 'docker login -u rishi236 -p ${docker}'

            sh 'docker push rishi236/spring:0.1'
        }

       }
       }
		stage('Deploy to staging gke'){
         when {
                branch 'main'
            }
        steps{
            
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
