pipeline {
    agent any // Use the master node as the agent

    parameters {
        booleanParam(name: 'RUN_SONARQUBE', defaultValue: false, description: 'Run SonarQube analysis?')
    }

    environment {
        SONAR_TOKEN = credentials('sonarid') // Sonar token
    }

    stages {
        stage('Checkout') {
            steps {
                script {
                    echo "Checking out code from GitHub..."
                }
                git branch: 'CHECKOUT', url: 'https://github.com/Arsenet7/revive-new.git', credentialsId: 'githubs'
            }
        }

        stage('Build and Unit Test') {
            agent {
                docker {
                    image 'maven:3.8.7-openjdk-18'
                    args '-u root'
                }
            }
            steps {
                echo 'Building project and running Unit Tests...'
                sh '''
                cd revive-orders/orders
                mvn clean compile
                mvn test
                '''
            }
        }

        stage('SonarQube Analysis') {
            environment {
                SCANNER_HOME = tool 'scan' // Define the SonarQube scanner tool
            }
            steps {
                script {
                    echo "Starting SonarQube analysis..."
                    echo "SonarQube URL: https://sonarqube.devopseasylearning.uk/"
                    echo "SonarQube Project Key: ORDERS-micro-ARSENE"

                    withSonarQubeEnv('sonar') { // 'scan' is the SonarQube server configured in Jenkins
                        sh """
                            ${SCANNER_HOME}/bin/sonar-scanner \
                            -Dsonar.projectKey=UI-micro \
                            -Dsonar.host.url=https://sonarqube.devopseasylearning.uk/ \
                            -Dsonar.login=${SONAR_TOKEN} \
                            -Dsonar.sources=./revive-orders/orders \
                            -Dsonar.java.binaries=./revive-ui/ui/src/main/java
                        """
                    }
                }
            }
        }

        stage('Docker Hub Login') {
            steps {
                script {
                    echo 'Logging into Docker Hub...'
                    withCredentials([usernamePassword(credentialsId: 'dockerhub-ars-id', usernameVariable: 'DOCKER_HUB_USER', passwordVariable: 'DOCKER_HUB_PASS')]) {
                        sh "echo ${DOCKER_HUB_PASS} | docker login -u ${DOCKER_HUB_USER} --password-stdin"
                    }
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    echo 'Building Docker image...'
                    sh '''
                        cd revive-ui/ui
                        docker build -t arsenet10/revive-orders:01 .
                    '''
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    echo 'Pushing Docker image to Docker Hub...'
                    sh '''
                        docker push arsenet10/revive-orders:01
                    '''
                }
            }
        }

        stage('Clean Workspace') {
            steps {
                script {
                    echo 'Cleaning up the workspace...'
                    cleanWs() // Clean the workspace at the end
                    sh '''
                        # Stop and remove containers if any exist
                        if [ "$(docker ps -aq)" ]; then
                            docker stop $(docker ps -aq)
                            docker rm $(docker ps -aq)
                        fi

                        # Remove images if any exist
                        if [ "$(docker images -q)" ]; then
                            docker rmi $(docker images -q)
                        fi
                    '''
                }
            }
        }
    }

    post {
        always {
            script {
                echo 'Final cleanup...'
                cleanWs() // Clean the workspace at the end
            }
        }
    }
}

