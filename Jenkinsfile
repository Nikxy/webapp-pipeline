pipeline {
    agent any
    environment {
        SCANNER_HOME = tool name: 'MainSonar';
        SNYK_HOME = tool name: 'snyk'
        IMAGE_NAME = "nikxy/webapp"
        DOCKER_CONTENT_TRUST_REPOSITORY_PASSPHRASE = credentials('DOCKER_TRUST_REPOSITORY_PASS')
        DOCKER_CONTENT_TRUST_ROOT_PASSPHRASE = credentials('DOCKER_TRUST_ROOT_PASS')
    }
    stages {
        /*stage('Dependency Check') {
            steps {
                dependencyCheck additionalArguments: '''
                --enableExperimental
                --scan 'app/'
                -f 'XML'
                --prettyPrint''',
                odcInstallation: 'dependency-check',
                nvdCredentialsId: 'NVD-API-KEY',
                stopBuild: true

                dependencyCheckPublisher pattern: 'dependency-check-report.xml',
                failedTotalCritical: 1,
                stopBuild: true
            }
        }*/
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
        stage('Scan Image'){
            steps {
                withCredentials([string(credentialsId: 'snyk-api-key', variable: 'TOKEN')]) {
                    sh '$SNYK_HOME/snyk-linux auth $TOKEN'
                    sh '$SNYK_HOME/snyk-linux container test $IMAGE_NAME:test --file=Dockerfile --json-file-output=snyk-output.json --severity-threshold=high'
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
    }
}