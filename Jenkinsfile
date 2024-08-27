pipeline {
    agent any
    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-credentials')
        DOCKER_IMAGE = "elxandre240194/hello-world-app:${env.BUILD_ID}"
    }
    stages {
        stage('Environment Information') {
            steps {
                sh 'uname -a'
                sh 'env | sort'
            }
        }
        stage('Debug and Prepare Workspace') {
            steps {
                sh 'pwd'
                sh 'ls -la'
                sh 'git --version'
                sh 'rm -rf .git'
            }
        }
        stage('Check Connectivity') {
            steps {
                sh 'ping -c 4 github.com'
                sh 'curl -I https://github.com'
            }
        }
        stage('Checkout') {
            steps {
                script {
                    try {
                        git branch: 'main', url: 'https://github.com/elxandre/test-TRG.git'
                    } catch (Exception e) {
                        echo "Git checkout failed. Trying alternative method."
                        sh 'git clone https://github.com/elxandre/test-TRG.git .'
                        sh 'git checkout main'
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
        }
        success {
            echo 'Pipeline succeeded!'
        }
        failure {
            echo 'Pipeline failed!'
        }
    }
}
