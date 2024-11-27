pipeline {
    agent any
    environment {
        AWS_REGION = 'us-east-1' // Update with your AWS region
        //TF_WORKSPACE = 'default' // Update with your desired workspace
        TF_VAR_BACKEND_BUCKET = 'terraform-state-27-11-2024' // Replace with your S3 bucket
        TF_VAR_BACKEND_DYNAMO_TABLE = 'dev-remote-statelock' // Replace with your DynamoDB table
    }
    stages {
        stage('Checkout') {
            steps {
                // Pull the Terraform code from your Git repository
                git branch: 'vpc', url: 'https://github.com/shashank1553/tf-S3.git'
            }
        } /*
        stage('Setup AWS Credentials') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-creds']]) {
                    script {
                        env.AWS_ACCESS_KEY_ID = sh(script: "echo $AWS_ACCESS_KEY_ID", returnStdout: true).trim()
                        env.AWS_SECRET_ACCESS_KEY = sh(script: "echo $AWS_SECRET_ACCESS_KEY", returnStdout: true).trim()
                    }
                }
            }
        }*/
        stage('Initialize Terraform') {
            steps {
                script {
                    sh """
                    terraform init \
                        -backend-config="bucket=${TF_VAR_BACKEND_BUCKET}" \
                        -backend-config="region=${AWS_REGION}" \
                        -backend-config="dynamodb_table=${TF_VAR_BACKEND_DYNAMO_TABLE}" \
                        -backend-config="key=terraform/state"
                    """
                }
            }
        }
        stage('Plan') {
            steps {
                script {
                   // sh "terraform workspace select ${TF_WORKSPACE} || terraform workspace new ${TF_WORKSPACE}"
                   sh "terraform plan -out=tfplan"
                    
                }
            }
        } /*
        stage('Apply') {
            steps {
                script {
                    sh "terraform apply -auto-approve tfplan"
                }
            }
        } */
        stage('Terraform Destroy') {
            when {
                expression {
                    return true  // Set to 'true' if you want to destroy the resources after testing
                }
            }
            steps {
                script {
                    // Destroy the resources managed by Terraform (if needed)
                    sh 'terraform destroy -auto-approve'
                }
            }
        } 
    }
    post {
        always {
            echo 'Cleaning up workspace'
            cleanWs()
        }
        success {
            echo 'Terraform execution successful'
        }
        failure {
            echo 'Terraform execution failed'
        }
    }
}
