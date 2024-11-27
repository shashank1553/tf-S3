pipeline {
    agent any

    /*environment {
        AWS_ACCESS_KEY_ID = credentials('aws-access-key-id')  // Set the AWS Access Key ID (use Jenkins credentials plugin)
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-access-key')  // Set the AWS Secret Access Key (use Jenkins credentials plugin)
        AWS_DEFAULT_REGION = 'us-east-1'  // Specify the AWS region
    }*/

    stages {
        stage('Checkout') {
            steps {
                // Checkout the Terraform configuration from your version control system (e.g., Git)
                 git branch: 'S3-dynamodb', url: 'https://github.com/shashank1553/tf-S3.git'
            }
        }

        stage('Terraform Init') {
            steps {
                script {
                    // Initialize Terraform working directory (downloads provider plugins, etc.)
                    sh 'terraform init'
                }
            }
        }

        stage('Terraform Format') {
            steps {
                script {
                    // Run terraform fmt to ensure proper formatting of Terraform files
                    sh 'terraform fmt -check -diff'
                }
            }
        }

        stage('Terraform Validate') {
            steps {
                script {
                    // Run terraform validate to ensure the configuration is syntactically valid
                    sh 'terraform validate'
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                script {
                    // Run terraform plan to show what changes will be made
                    sh 'terraform plan -out=tfplan'
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                script {
                    // Apply the Terraform plan to create/update the resources
                    // The `-auto-approve` flag ensures it runs without asking for confirmation
                    sh 'terraform apply -auto-approve tfplan'
                }
            }
        }

        stage('Terraform Destroy') {
            when {
                expression {
                    return false  // Set to 'true' if you want to destroy the resources after testing
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
            // Clean up any resources or files after the pipeline run
            echo 'Cleaning up...'
        }
         success {
            echo 'Terraform execution successful'
        }
        failure {
            echo 'Terraform execution failed'
        }
    }
}
