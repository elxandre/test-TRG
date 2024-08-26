pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-credentials') // Set this up in Jenkins credentials
        DOCKER_IMAGE = "elxandre240194/hello-world-app:${env.BUILD_ID}"
    }

    stages {
        stage('Checkout') {
            steps {
                // Pull the latest code from the GitHub repository
                git branch: 'main', url: 'https://github.com/elxandre/test-TRG.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Build the Docker image for the Python app
                    docker.build(DOCKER_IMAGE)
                }
            }
        }

        stage('Push Docker Image to Docker Hub') {
            steps {
                script {
                    // Push the Docker image to Docker Hub
                    docker.withRegistry('https://index.docker.io/v1/', DOCKERHUB_CREDENTIALS) {
                        docker.image(DOCKER_IMAGE).push()
                    }
                }
            }
        }

        stage('Cleanup') {
            steps {
                script {
                    // Optionally clean up images to free space
                    docker.image(DOCKER_IMAGE).remove()
                }
            }
        }
    }

    post {
        success {
            echo 'Pipeline succeeded!'
        }
        failure {
            echo 'Pipeline failed!'
        }
    }
}
