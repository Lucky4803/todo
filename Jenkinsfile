pipeline {
    agent any

    stages {
        stage("Code Clone") {
            steps {
                echo "Code Clone Stage"
                git url: "https://github.com/Lucky4803/todo.git", branch: "main"
            }
        }

        stage("Code Build & Test") {
            steps {
                echo "Code Build Stage"
                withCredentials([usernamePassword(
                    credentialsId: "dockerHubCreds",
                    usernameVariable: "dockerHubUser", 
                    passwordVariable: "dockerHubPass"
                )]) {
                    sh 'echo $dockerHubPass | docker login -u $dockerHubUser --password-stdin'
                    sh """
                        docker pull $dockerHubUser/node-app:latest || true
                        docker build --cache-from=$dockerHubUser/node-app:latest -t node-app .
                    """
                }
            }
        }

        stage("Push To DockerHub") {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: "dockerHubCreds",
                    usernameVariable: "dockerHubUser", 
                    passwordVariable: "dockerHubPass"
                )]) {
                    sh 'echo $dockerHubPass | docker login -u $dockerHubUser --password-stdin'
                    sh "docker image tag node-app:latest $dockerHubUser/node-app:latest"
                    sh "docker push $dockerHubUser/node-app:latest"
                }
            }
        }

        stage("Deploy") {
            steps {
                sh "docker compose down || true"
                sh "docker compose up -d --build"
            }
        }
    }
}
