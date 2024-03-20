pipeline {
    agent any
    environment {
        scannerHome = tool name: 'MainSonar';
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
                    sh "${scannerHome}/bin/sonar-scanner -Dsonar.projectKey=WebApp -Dsonar.sources=./app -Dsonar.python.version=3"
                }
                steps {
                    timeout(time: 2, unit: 'MINUTES') {
                        waitForQualityGate abortPipeline: true
                    }
                }
            }
        }
    }
}