pipeline {
    agent any

    environment {
        DOCKER_BUILDKIT = '1' // Enables BuildKit for better caching
    }

    stages {
        stage("Code Clone") {
            steps {
                echo "Cloning code..."
                git url: "https://github.com/Lucky4803/todo.git", branch: "main"
            }
        }

        stage("Docker Build with Cache") {
            steps {
                echo "Building Docker image with cache..."
                withCredentials([usernamePassword(
                    credentialsId: "dockerHubCreds",
                    usernameVariable: "dockerHubUser", 
                    passwordVariable: "dockerHubPass"
                )]) {
                    sh '''
                        echo "$dockerHubPass" | docker login -u "$dockerHubUser" --password-stdin

                        # Try to pull the latest image to use its cache
                        docker pull $dockerHubUser/node-app:latest || true

                        # Build the image using cache-from and inline caching
                        docker build \
                          --cache-from=$dockerHubUser/node-app:latest \
                          --build-arg BUILDKIT_INLINE_CACHE=1 \
                          -t node-app:latest .
                    '''
                }
            }
        }

        stage("Push to DockerHub") {
            steps {
                echo "Pushing image to DockerHub..."
                withCredentials([usernamePassword(
                    credentialsId: "dockerHubCreds",
                    usernameVariable: "dockerHubUser", 
                    passwordVariable: "dockerHubPass"
                )]) {
                    sh '''
                        echo "$dockerHubPass" | docker login -u "$dockerHubUser" --password-stdin
                        docker tag node-app:latest $dockerHubUser/node-app:latest
                        docker push $dockerHubUser/node-app:latest
                    '''
                }
            }
        }

        stage("Deploy with Compose") {
            steps {
                echo "Deploying with Docker Compose..."
                sh '''
                    docker compose down || true
                    docker compose up -d --build
                '''
            }
        }
    }
}
