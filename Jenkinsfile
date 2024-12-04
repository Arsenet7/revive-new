pipeline {
    agent any
    parameters {
        string(name: 'REMOTE_PASS', defaultValue: '', description: 'Password for remote server')
    }
    environment {
        REMOTE_HOST = "3.145.98.231"  // Replace with your server address
        REMOTE_USER = "jenkins"       // Replace with your server username
        GIT_BRANCH = "main"           // Replace with your desired Git branch
        GIT_REPO = "https://github.com/Arsenet7/revive-new.git" // Replace with your Git repo URL
        REPO_NAME = "revive-new"      // The directory name of the repository
    }
    stages {
        stage('Connect to Remote Server') {
            steps {
                script {
                    echo "Connecting to remote server..."
                    sh """
                        sshpass -p '${params.REMOTE_PASS}' ssh -o StrictHostKeyChecking=no $REMOTE_USER@$REMOTE_HOST echo "Connected Successfully"
                    """
                }
            }
        }
        stage('Git Clone on Remote Server') {
            steps {
                script {
                    echo "Cloning repository on remote server..."
                    sh """
                        sshpass -p '${params.REMOTE_PASS}' ssh $REMOTE_USER@$REMOTE_HOST "
                        rm -rf $REPO_NAME &&
                        git clone -b $GIT_BRANCH $GIT_REPO
                        "
                    """
                }
            }
        }
        stage('Deploy with Docker Compose') {
            steps {
                script {
                    echo "Deploying with Docker Compose on remote server..."
                    withCredentials([usernamePassword(credentialsId: 'dockerhub-ars-id', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                        sh """
                            sshpass -p '${params.REMOTE_PASS}' ssh $REMOTE_USER@$REMOTE_HOST "
                            cd $REPO_NAME &&
                            echo '${params.REMOTE_PASS}' | sudo -S docker login -u \$DOCKER_USERNAME -p \$DOCKER_PASSWORD &&
                            sudo docker-compose up -d
                            "
                        """
                    }
                }
            }
        }
    }
    post {
        always {
            echo "Pipeline completed."
        }
        success {
            echo "Pipeline succeeded."
        }
        failure {
            echo "Pipeline failed."
        }
    }
}
