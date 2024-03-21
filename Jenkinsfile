pipeline {
    agent any
    environment {
        SCANNER_HOME = tool name: 'MainSonar';
        SNYK_HOME = tool name: 'snyk'
        TERRAFORM_HOME = tool name: 'Terraform'
        IMAGE_NAME = "nikxy/webapp"
        AWS_REGION = 'il-central-1'
        DOCKER_CONTENT_TRUST_REPOSITORY_PASSPHRASE = credentials('DOCKER_TRUST_REPOSITORY_PASS')
        DOCKER_CONTENT_TRUST_ROOT_PASSPHRASE = credentials('DOCKER_TRUST_ROOT_PASS')
    }
    stages {
        stage('Static Code Analysis') {
            steps {
                withSonarQubeEnv(installationName: 'MainSonar', credentialsId: "Sonarqube") {
                    sh "${SCANNER_HOME}/bin/sonar-scanner -Dsonar.projectKey=WebApp -Dsonar.sources=./app -Dsonar.python.version=3"
                }
                timeout(time: 2, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }
        stage('Build Image') {
            steps {
                sh 'docker build -t $IMAGE_NAME:test .'
            }
        }
        stage('Scan Image and Dependencies'){
            steps {
                withCredentials([string(credentialsId: 'snyk-api-key', variable: 'TOKEN')]) {
                    sh '$SNYK_HOME/snyk-linux auth $TOKEN'
                }
                script { def snyk_scan = true }
                sh '$SNYK_HOME/snyk-linux container test $IMAGE_NAME:test --file=Dockerfile --json-file-output=snyk-output.json --severity-threshold=high'
            }
        }
        stage('Test Image') {
            steps {
                sh 'docker run --rm -d --name project-test -p 80:8000 $IMAGE_NAME:test'
                script {
                    docker_ran = true
                    sh 'python3 tests/test.py'
                    sh 'docker kill project-test'
                    docker_ran = false
                    sh 'docker tag $IMAGE_NAME:test $IMAGE_NAME:latest'
                }
            }
        }
        stage('Push Image') {
            steps {
                withCredentials([usernamePassword(
                            credentialsId: 'docker-hub-access-token',
                            usernameVariable: 'DOCKERHUB_USER',
                            passwordVariable: 'DOCKERHUB_KEY'
                        )]) {
                    sh 'docker login -u $DOCKERHUB_USER -p $DOCKERHUB_KEY'
                }
                sh 'docker tag $IMAGE_NAME:latest $IMAGE_NAME:build-$BUILD_NUMBER'
                sh 'docker push $IMAGE_NAME:build-$BUILD_NUMBER'
                sh 'docker trust sign $IMAGE_NAME:build-$BUILD_NUMBER'
                sh 'docker image rm $IMAGE_NAME:build-$BUILD_NUMBER'
                sh 'docker push $IMAGE_NAME'
                sh 'docker trust sign $IMAGE_NAME:latest'
                sh 'docker logout'
            }
        }
        stage('Terraform init') {
            steps {
                withCredentials([aws(
                    credentialsId: 'webapp-aws',
                    accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                    secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'                
                )]) {
                    dir("terraform/deployment") {
                        sh '$TERRAFORM_HOME/terraform init'
                    }
                }
            }
        }
        stage('Terraform apply') {
            steps {
                withCredentials([aws(
                    credentialsId: 'webapp-aws',
                    accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                    secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'                
                )]) {
                    dir("terraform/deployment") {
                        configFileProvider(
                            [configFile(fileId:'terraform-input-variables', variable:'TERRAFORM_VARS')]) {
                            sh '$TERRAFORM_HOME/terraform apply --auto-approve -var-file=$TERRAFORM_VARS -var app_image="$IMAGE_NAME:build-$BUILD_NUMBER"'
                        }
                    }
                }
            }
        }
    }
    post {
        always {
            script {
                if(snyk_scan){
                    sh '$SNYK_HOME/snyk-to-html-linux -i snyk-output.json -o snyk-output.html'
                    publishHTML([
                        reportName: 'Snyk Results',
                        reportDir: './',
                        reportFiles: 'snyk-output.html',
                        allowMissing: true,
                        alwaysLinkToLastBuild: true,
                        keepAll: true
                    ])
                }
            }
        }
    }
}