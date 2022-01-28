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
   stage{'Create Server'} {
     steps{
      sh 'bash ec2launch.sh ${COMPONENT} ${ENV}'
      }
   }
 }
}