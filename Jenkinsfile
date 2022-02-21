pipeline {
 agent { label 'workstation'}
 options {
         ansiColor('xterm')
 }

 parameters {
     choice(name: 'ENV', choices: ['DEV','PROD'], description: 'choose ENV')
     string(name: 'COMPONENT', defaultValue: '', description: 'Which App Component')
 }

 environment {
 SSH= credentials('CENTOS')
 }

 stages {
   stage('Create Server') {
     steps{
      sh 'bash ec2launch.sh ${COMPONENT} ${ENV}'
      }
   }

   stage('Ansible playbook run') {
      steps{
      script {
      env.ANSIBLE_TAG=COMPONENT.toUpperCase{}
      }
       sh 'ansible-playbook -i roboshop.inv roboshop.yml -e  ENV=${ENV} -t ${ANSIBLE_TAG} -e ansible_password=$(SSH_PSW) -u $(SSH_USR)'
      }
   }

 }
}