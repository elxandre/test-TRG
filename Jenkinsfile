pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-credentials') // Store Docker Hub credentials in Jenkins
        DOCKER_IMAGE = "elxandre240194/hello-world-app:${env.BUILD_ID}" // Name the Docker image with a build ID
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'github.com/elxandre/test-TRG'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build(DOCKER_IMAGE)
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', DOCKERHUB_CREDENTIALS) {
                        docker.image(DOCKER_IMAGE).push()
                    }
                }
            }
        }

        stage('Deploy to Kubernetes via ArgoCD') {
            steps {
                // Here we would trigger ArgoCD to pull the latest image and update the deployment
                sh 'kubectl apply -f deployment.yaml'
                // Or if using ArgoCD's CLI:
                // sh 'argocd app sync my-application'
            }
        }
    }

    post {
        success {
            echo 'Pipeline succeeded.'
        }
        failure {
            echo 'Pipeline failed.'
        }
    }
}
