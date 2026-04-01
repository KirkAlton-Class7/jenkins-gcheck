// ============================================================================
// JENKINSFILE - DevSecOps Pipeline
// ============================================================================
// Deploys AWS infrastructure via Terraform. Triggered by GitHub webhook pushes.
// ============================================================================

pipeline {
    agent any  // Runs on any Jenkins agent (local Docker for this lab)
   
    environment {
        AWS_REGION = 'us-west-2'
    }
    
    stages {
        
        // --------------------------------------------------------------------
        // STAGE: Set AWS Credentials
        // --------------------------------------------------------------------
        // Fails fast by verifying credentials before any real work.
        // withCredentials injects AWS keys from Jenkins credential 'aws-iam-user-creds'.
        // --------------------------------------------------------------------
        stage('Set AWS Credentials') {
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'aws-iam-user-creds'
                ]]) {
                    sh '''
                    aws sts get-caller-identity  # Returns Account ID, User ARN
                    '''
                }
            }
        }
        
        // --------------------------------------------------------------------
        // STAGE: Checkout Code
        // --------------------------------------------------------------------
        // Pulls latest code from GitHub. The webhook trigger ensures this runs
        // immediately after each push to main.
        // --------------------------------------------------------------------
        stage('Checkout Code') {
            steps {
                git branch: 'main', 
                    url: 'https://github.com/KirkAlton-Class7/jenkins-gcheck' 
            }
        }

        // ====================================================================
        // JFROG ARTIFACTORY STAGE (Commented - Keep for Reference)
        // ====================================================================
        // Artifactory is a universal artifact repository for binaries, Docker
        // images, and dependencies. Uncomment this when you need to store
        // compiled code, scan for vulnerabilities, or promote the same artifact
        // across environments (dev → test → prod) without rebuilding.
        //
        // To enable: install JFrog CLI in the Jenkins container, add a Jenkins
        // credential named 'jfrog-creds', then uncomment the stage below.
        // The commands verify the CLI, test connectivity, upload a file, and
        // publish build metadata.
        // ====================================================================
        // stage('Testing') {
        //     steps {
        //         withCredentials([string(credentialsId: 'jfrog-creds', variable: 'JFROG_TOKEN')]) {
        //             jf '-v'
        //             jf 'rt ping'
        //             sh 'touch test-file'
        //             sh 'jf rt upload test-file tf-terraform/ --url=https://your-artifactory.jfrog.io --user=your-username --password=$JFROG_TOKEN'
        //             jf 'rt bp'
        //         }
        //     } 
        // }

        // --------------------------------------------------------------------
        // STAGE: Initialize Terraform
        // --------------------------------------------------------------------
        // Always the first Terraform command. Downloads providers and sets up
        // backend storage. AWS credentials are exported because Terraform reads
        // them directly from environment variables.
        // --------------------------------------------------------------------
        stage('Initialize Terraform') {
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'aws-iam-user-creds'
                ]]) {
                    sh '''
                    export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
                    export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
                    terraform init
                    '''
                }
            }
        }

        // --------------------------------------------------------------------
        // STAGE: Validate Terraform
        // --------------------------------------------------------------------
        // Quick syntax check. No credentials needed because this only validates
        // HCL structure, not provider configuration or resource existence.
        // --------------------------------------------------------------------
        stage('Validate') {
            steps {
                sh 'terraform validate'
            }
        }

        // --------------------------------------------------------------------
        // STAGE: Format Terraform
        // --------------------------------------------------------------------
        // Enforces consistent code style across the team. Automatically fixes
        // formatting issues. No credentials required.
        // --------------------------------------------------------------------
        stage('Format Terraform') {
            steps {
                sh 'terraform fmt'
            }
        }

        // --------------------------------------------------------------------
        // STAGE: Plan Terraform
        // --------------------------------------------------------------------
        // Previews what Terraform will change and saves the plan to tfplan.
        // This file ensures the apply stage uses exactly what was reviewed,
        // preventing drift between planning and execution.
        // --------------------------------------------------------------------
        stage('Plan Terraform') {
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'aws-iam-user-creds'
                ]]) {
                    sh '''
                    export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
                    export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
                    terraform plan -out=tfplan
                    '''
                }
            }
        }

        // --------------------------------------------------------------------
        // STAGE: Apply Terraform (MANUAL APPROVAL)
        // --------------------------------------------------------------------
        // The input() step creates a manual approval gate. The pipeline pauses
        // until a user clicks "Deploy" in the Jenkins UI. Combined with the
        // saved tfplan and -auto-approve flag, this gives safe, repeatable
        // automation without interactive prompts.
        // --------------------------------------------------------------------
        stage('Apply Terraform') {
            steps {
                input message: "Approve Terraform Apply?", ok: "Deploy"
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'aws-iam-user-creds'
                ]]) {
                    sh '''
                    export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
                    export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
                    terraform apply -auto-approve tfplan
                    '''
                }
            }
        }

        // --------------------------------------------------------------------
        // STAGE: Optional Destroy (MANUAL CHOICE)
        // --------------------------------------------------------------------
        // After a successful apply, the pipeline asks whether to destroy
        // resources. Select 'yes' for labs to avoid AWS charges. Never
        // auto-destroy production resources.
        // --------------------------------------------------------------------
        stage('Optional Destroy') {
            steps {
                script {
                    def destroyChoice = input(
                        message: 'Do you want to run terraform destroy?',
                        ok: 'Submit',
                        parameters: [
                            choice(
                                name: 'DESTROY',
                                choices: ['no', 'yes'],
                                description: 'Select yes to destroy resources'
                            )
                        ]
                    )

                    if (destroyChoice == 'yes') {
                        withCredentials([[
                            $class: 'AmazonWebServicesCredentialsBinding',
                            credentialsId: 'aws-iam-user-creds'
                        ]]) {
                            sh 'terraform destroy -auto-approve'
                        }
                    } else {
                        echo "Skipping destroy"
                    }
                }
            }
        }
    }

    // --------------------------------------------------------------------
    // POST: Run after all stages
    // --------------------------------------------------------------------
    // Executes regardless of success or failure. Ideal for notifications,
    // cleanup, or archiving. Slack integration examples are commented.
    // --------------------------------------------------------------------
    post {
        success {
            echo '✅ Terraform deployment completed!'
            // Future: slackSend(color: 'good', message: 'Deployment successful')
        }
        failure {
            echo '❌ Terraform deployment failed!'
            // Future: slackSend(color: 'danger', message: 'Deployment failed')
        }
    }
}