pipeline {
    agent any
    stages {
        stage('Terraform Destroy') {
            steps {
                script {
                    sh '''
                    terraform init
                    terraform destroy -auto-approve
                    '''
                }
            }
        }
    }
}
