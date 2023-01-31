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
		stage('Docker Image Build'){
			steps{
				script{
					sh 'docker image build -t $JOB_NAME:v1.$BUILD_ID .'
					sh 'docker image tag $JOB_NAME:v1.$BUILD_ID rishi236/$JOB_NAME:v1.$BUILD_ID'
					sh 'docker image tag $JOB_NAME:v1.$BUILD_ID rishi236/$JOB_NAME:latest'
				}
			}
		}
		stage('Push Image to the DockerHub'){
			steps{
				script{
					withCredentials([string(credentialsId: 'docker_creds', variable: 'docker')]) {
						
						sh 'docker login -u rishi236 -p ${docker}'
					    sh 'docker image push rishi236/$JOB_NAME:v1.$BUILD_ID'
					    sh 'docker image push rishi236/$JOB_NAME:latest'
					}
				}
			}
		}
		stage('Deploy to GKE') {
            steps{
                sh "sed -i 's/spring:latest/spring:${env.BUILD_ID}/g' deployment.yaml"
                step([$class: 'KubernetesEngineBuilder', 
		      projectId: env.PROJECT_ID, 
		      clusterName: env.CLUSTER_NAME, 
		      location: env.LOCATION, 
		      manifestPattern: 'deployment.yaml', 
		      credentialsId: env.CREDENTIALS_ID, 
		      verifyDeployments: true])
            }
        }
    }
}
