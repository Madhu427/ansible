pipeline {
 agent { label 'workstation-1'}
 options {
         ansiColor('xterm')
 }

 parameters {
     choice(name: 'ENV', choices: ['dev','prod'], description: 'choose Env')
     string(name: 'COMPONENT', defaultValue: '', description: 'Which App Component')
 }

 stages {
   stage('Create Server') {
     steps{
      sh 'bash ec2launch.sh ${COMPONENT} ${ENV}'
      }
   }

   stage('Ansible playbook run') {
      steps{
       sh 'ansible-playbook -i roboshop.inv roboshop.yml -e  ENV=${ENV}'
      }
   }

 }
}