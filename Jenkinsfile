pipeline {
    agent any
    options {
        skipDefaultCheckout(true)
    }
    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-credentials')
        DOCKER_IMAGE = "elxandre240194/hello-world-app:${env.BUILD_ID}"
    }
    stages {
        stage('Clean Workspace') {
            steps {
                cleanWs()
            }
        }
        stage('Check Environment') {
            steps {
                sh 'uname -a'
                sh 'which git'
                sh 'git --version'
                sh 'id'
                sh 'pwd'
                sh 'ls -la'
                sh 'env | sort'
            }
        }
        stage('Checkout') {
            steps {
                script {
                    try {
                        sh 'git init'
                        sh 'git remote add origin https://github.com/elxandre/test-TRG.git'
                        sh 'git fetch --all'
                        sh 'git checkout -B main origin/main'
                    } catch (Exception e) {
                        echo "Git operations failed. Error: ${e.message}"
                        error "Failed to checkout repository"
                    }
                }
            }
        }
        stage('Verify Checkout') {
            steps {
                sh 'ls -la'
                sh 'git status'
                sh 'git remote -v'
            }
        }
        stage('Check Connectivity') {
            steps {
                sh 'ping -c 4 github.com'
                sh 'curl -I https://github.com'
            }
        }
        stage('Check Docker') {
            steps {
                sh 'docker info'
                sh 'docker version'
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    try {
                        docker.build(DOCKER_IMAGE)
                    } catch (Exception e) {
                        echo "Docker build failed. Error: ${e.message}"
                        error "Failed to build Docker image"
                    }
                }
            }
        }
        stage('Push Docker Image to Docker Hub') {
            steps {
                script {
                    try {
                        docker.withRegistry('https://index.docker.io/v1/', DOCKERHUB_CREDENTIALS) {
                            docker.image(DOCKER_IMAGE).push()
                        }
                    } catch (Exception e) {
                        echo "Docker push failed. Error: ${e.message}"
                        error "Failed to push Docker image"
                    }
                }
            }
        }
        stage('Cleanup') {
            steps {
                script {
                    try {
                        docker.image(DOCKER_IMAGE).remove()
                    } catch (Exception e) {
                        echo "Cleanup failed. Error: ${e.message}"
                    }
                }
            }
        }
    }
    post {
        always {
            echo 'Printing workspace contents after job execution:'
            sh 'ls -la'
            cleanWs()
        }
        success {
            echo 'Pipeline succeeded!'
        }
        failure {
            echo 'Pipeline failed!'
        }
    }
}
