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
                    dir("app/") {
                        sh "${scannerHome}/bin/sonar-scanner"
                    }
                }
                timeout(time: 2, unit: 'MINUTES') {
                    script {
                        def qg = waitForQualityGate()
                        if (qg.status != 'OK') {
                            error "Pipeline aborted due to quality gate failure: ${qg.status}"
                        }
                    }
                }
            }
        }
    }
}