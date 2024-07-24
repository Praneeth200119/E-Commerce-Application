pipeline {
    agent any
    
    stages {
        stage("clone code") {
            steps {
                echo "cloning the code"
                git url: "https://github.com/saishadow5473/comm-client.git", branch: "main"
            }
        }
        stage("build") {
            steps {
                echo "building the image"
                sh "docker build -t client ."
            }
        }
        stage("push to dockerhub") {
            steps {
                echo "push to dockerhub"
                withCredentials([usernamePassword(credentialsId: "dockerHub", passwordVariable: "dockerHubPass", usernameVariable: "dockerHubUser")]) {
                    sh "docker tag client ${env.dockerHubUser}/client:latest"
                    sh "docker login -u ${env.dockerHubUser} -p ${env.dockerHubPass}"
                    sh "docker push ${env.dockerHubUser}/client:latest"
                }
            }
        }
        stage("Run Docker Container") {
            steps {
                script {
                    // Check if the container exists and stop/remove it if it does
                    sh '''
                    if docker ps -a --format '{{.Names}}' | grep -q my-container; then
                        docker stop my-container || true
                        docker rm my-container || true
                    fi
                    docker pull ${dockerImageName}:latest || true
                    docker run -d --name my-container -p 80:80 client:latest
                    '''
                }
            }
        }
    }
}
