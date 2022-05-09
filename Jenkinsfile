pipeline {
    agent any

    environment {
        SELENIUM_BROWSER = 'chrome'
    }

    stages {
        stage('Build and Test only') {
            when {
               not {
                   anyOf {
                        branch 'main'
                        branch '2021.06'
                        branch '2021.06.x'
                   }
               }
            }
            steps {
                withMaven (maven: 'mvn', jdk: 'OJDK11') {
                    sh 'mvn -U clean verify'
                }
            }
        }

        stage('Build, Test and Deploy') {
            when {
               anyOf {
                    branch 'main'
                    branch '2021.06'
                    branch '2021.06.x'
               }
            }
            steps {
                    withMaven (maven: 'mvn', jdk: 'OJDK11', mavenSettingsConfig: 'maven-deploy-settings') {
                        withCredentials([
                        usernamePassword(credentialsId: 'ossrhs01', passwordVariable: 'PASSWORD_VAR', usernameVariable: 'USERNAME_VAR'),
                        usernamePassword(credentialsId: 'gpg', passwordVariable: 'KEYPW_VAR', usernameVariable: 'KEYID_VAR')
                        ])
                        {
                            sh 'mvn -U clean deploy -Dgpg.executable=gpg -Dgpg.keyname=${KEYID_VAR} -Dgpg.passphrase=${KEYPW_VAR} -Dossrhs01.username=${USERNAME_VAR} -Dossrhs01.password=${PASSWORD_VAR}'
                        }
                    }
            }
        }
    }

}
