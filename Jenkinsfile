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

        stage('Ansible Deployment') {
            steps {
                script {
                    ansiblePlaybook(
                        playbook: 'amazon-playbook.yml',
                        inventory: 'inventory.ini',
                        extras: "-e 'ansible_ssh_user=ec2-user -e ansible_ssh_private_key_file=~/.ssh/${AMAZON_KEY_PAIR}.pem'"
                    )

                    ansiblePlaybook(
                        playbook: 'ubuntu-playbook.yml',
                        inventory: 'inventory.ini',
                        extras: "-e 'ansible_ssh_user=ubuntu -e ansible_ssh_private_key_file=~/.ssh/${UBUNTU_KEY_PAIR}.pem'"
                    )
                }
            }
        }
    }
}
