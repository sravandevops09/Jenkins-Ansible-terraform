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
            // Load Jenkins SSH credential and set variables
            withCredentials([sshUserPrivateKey(credentialsId: 'private_key', 
                                               keyFileVariable: 'ANSIBLE_KEY', 
                                               usernameVariable: 'ANSIBLE_USER')]) {

                // Deploy frontend (Amazon Linux)
                ansiblePlaybook(
                    playbook: 'amazon-playbook.yml',
                    inventory: 'inventory.ini',
                    limit: 'frontend',
                    extras: "--private-key ${ANSIBLE_KEY} -u ${ANSIBLE_USER} --ssh-extra-args='-o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no'"
                )

                // Deploy backend (Ubuntu)
                ansiblePlaybook(
                    playbook: 'ubuntu-playbook.yml',
                    inventory: 'inventory.ini',
                    limit: 'backend',
                    extras: "--private-key ${ANSIBLE_KEY} -u ${ANSIBLE_USER} --ssh-extra-args='-o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no'"
                )
            }
        }
    }
}





    }
}
