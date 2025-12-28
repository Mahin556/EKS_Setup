pipeline {
    agent any

    options {
        timestamps()
        disableConcurrentBuilds()
    }

    parameters {
        choice(
            name: 'ACTION',
            choices: ['apply', 'destroy'],
            description: 'Select Terraform action'
        )
    }

    environment {
        AWS_DEFAULT_REGION = 'ap-south-1'
        TF_IN_AUTOMATION   = 'true'
        CLUSTER_NAME      = 'todo-app-eks'
    }

    stages {

        stage('Checkout Source Code') {
            steps {
                echo 'Checking out source code from GitHub...'
                checkout scmGit(
                    branches: [[name: '*/3-jenkins']],
                    userRemoteConfigs: [[
                        url: 'https://github.com/Mahin556/EKS_Setup.git'
                    ]]
                )
            }
        }

        stage('Terraform Init') {
            steps {
                withCredentials([
                    string(credentialsId: 'AWS_ACCESS_KEY_ID',     variable: 'AWS_ACCESS_KEY_ID'),
                    string(credentialsId: 'AWS_SECRET_ACCESS_KEY', variable: 'AWS_SECRET_ACCESS_KEY')
                ]) {
                    dir('EKS') {
                        echo 'Initializing Terraform...'
                        sh 'terraform init'
                    }
                }
            }
        }

        stage('Terraform Format Check') {
            steps {
                dir('EKS') {
                    echo 'Checking Terraform code format...'
                    sh 'terraform fmt -check'
                }
            }
        }

        stage('Terraform Validate') {
            steps {
                dir('EKS') {
                    echo 'Validating Terraform configuration...'
                    sh 'terraform validate'
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                withCredentials([
                    string(credentialsId: 'AWS_ACCESS_KEY_ID',     variable: 'AWS_ACCESS_KEY_ID'),
                    string(credentialsId: 'AWS_SECRET_ACCESS_KEY', variable: 'AWS_SECRET_ACCESS_KEY')
                ]) {
                    dir('EKS') {
                        echo 'Creating Terraform plan...'
                        sh 'terraform plan -out=tfplan'
                    }
                }
            }
        }

        stage('Manual Approval') {
            steps {
                input(
                    message: "Do you want to ${params.ACTION} the EKS infrastructure?",
                    ok: "Yes, Proceed"
                )
            }
        }

        stage('Terraform Apply / Destroy') {
            steps {
                withCredentials([
                    string(credentialsId: 'AWS_ACCESS_KEY_ID',     variable: 'AWS_ACCESS_KEY_ID'),
                    string(credentialsId: 'AWS_SECRET_ACCESS_KEY', variable: 'AWS_SECRET_ACCESS_KEY')
                ]) {
                    dir('EKS') {
                        script {
                            if (params.ACTION == 'apply') {
                                echo 'Applying Terraform plan...'
                                sh 'terraform apply -auto-approve'
                            } else {
                                echo 'Destroying Terraform-managed infrastructure...'
                                sh 'terraform destroy -auto-approve'
                            }
                        }
                    }
                }
            }
        }

        stage('Update Kubeconfig') {
            when {
                expression { params.ACTION == 'apply' }
            }
            steps {
                withCredentials([
                    string(credentialsId: 'AWS_ACCESS_KEY_ID',     variable: 'AWS_ACCESS_KEY_ID'),
                    string(credentialsId: 'AWS_SECRET_ACCESS_KEY', variable: 'AWS_SECRET_ACCESS_KEY')
                ]) {
                    echo 'Updating kubeconfig for EKS cluster...'
                    sh '''
                      aws eks update-kubeconfig \
                        --region ${AWS_DEFAULT_REGION} \
                        --name todo-app-eks
                    '''
                }
            }
        }

        stage('Cluster Verification') {
            when {
                expression { params.ACTION == 'apply' }
            }
            steps {
                echo 'Verifying EKS cluster status...'
                sh '''
                  kubectl get nodes
                  kubectl get pods -A
                '''
            }
        }
    }

    post {
        success {
            echo "Pipeline completed successfully"
        }
        failure {
            echo "Pipeline failed – check logs"
        }
        always {
            cleanWs()
        }
    }
}
