pipeline {
    agent any

    environment {
        AWS_REGION = 'us-east-1'
        AMAZON_KEY_PAIR = 'jenkins-key'
        UBUNTU_KEY_PAIR = 'jenkins-key'
    }

    stages {
        

        stage('Checkout') {
            steps {
                checkout([$class: 'GitSCM', branches: [[name: '*/main']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[credentialsId: '', url: 'https://github.com/sravandevops09/Jenkins-Ansible-terraform.git']]]) 
            }
        }
        

        stage('Terraform Apply') {
            steps {
                withAWS(credentials: 'aws_keys') {
                    sh '''
                        echo "Running Terraform..."
                        terraform init
                        terraform plan
                        terraform apply -auto-approve
                    '''
                }
            }
        }

        stage('Generate Inventory') {
    steps {
        sh '''
            chmod +x generate_inventory.sh
            ./generate_inventory.sh
        '''
    }
}


stage('Ansible Deployment') {
    steps {
        script {
            // Wrap withCredentials to inject the SSH key
            withCredentials([sshUserPrivateKey(credentialsId: 'private_key', 
                                              keyFileVariable: 'ANSIBLE_KEY', 
                                              usernameVariable: 'ANSIBLE_USER')]) {
                // Frontend (Amazon Linux)
                ansiblePlaybook(
                    playbook: 'amazon-playbook.yml',
                    inventory: 'inventory.ini',
                    limit: 'frontend',
                    extras: "--private-key ${ANSIBLE_KEY} -u ec2-user --ssh-extra-args='-o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no'"
                )

                // Backend (Ubuntu)
                ansiblePlaybook(
                    playbook: 'ubuntu-playbook.yml',
                    inventory: 'inventory.ini',
                    limit: 'backend',
                    extras: "--private-key ${ANSIBLE_KEY} -u ubuntu --ssh-extra-args='-o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no'"
                )
            }
        }
    }
}




    }
}
