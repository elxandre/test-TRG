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
                sh 'curl -I https://github.com'
            }
        }
        stage('Check Docker') {
            steps {
                sh 'docker version'
                sh 'docker info'
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
                        docker.withRegistry('https://index.docker.io/v1/', 'dockerhub-credentials') {
                            docker.image(DOCKER_IMAGE).push()
                        }
                    } catch (Exception e) {
                        echo "Docker push failed. Error: ${e.message}"
                        error "Failed to push Docker image"
                    }
                }
            }
        }
         stage('Run Tests in Staging') {
            steps {
                script {
                    try {
                        // Deploy to staging
                        sh "kubectl apply -f k8s/staging -n staging"
                        
                        // Run tests
                        sh "kubectl run test-pod -n staging --image=${DOCKER_IMAGE} --command -- ./run_tests.sh"
                        
                        // Wait for tests to complete
                        sh "kubectl wait --for=condition=complete job/test-pod -n staging --timeout=300s"
                        
                        // Collect results
                        sh "kubectl cp staging/test-pod:/test-results ./test-results"
                        
                        // Publish results to Jenkins
                        junit '**/test-results/*.xml'
                    } catch (Exception e) {
                        echo "Staging tests failed. Error: ${e.message}"
                        error "Failed to run staging tests"
                    } finally {
                        // Cleanup staging environment
                        sh "kubectl delete -f k8s/staging -n staging"
                        sh "kubectl delete pod test-pod -n staging"
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
