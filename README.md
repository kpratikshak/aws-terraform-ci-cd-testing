## Terraform CI/CD Pipeline for AWS Modules:

This repository implements a robust CI/CD system to automate the testing and deployment of Terraform modules on AWS. 
It addresses the challenges of manual deployments, which often lead to misconfigured infrastructure, security vulnerabilities, and unscalable cloud environments.

## Problem Statement:
Manual Terraform deployments lack automated testing and validation, increasing the risk of human error. 
This pipeline solves that problem by creating a repeatable and secure workflow that validates infrastructure changes before they are deployed.

# Architecture Overview:

This CI/CD pipeline uses a combination of AWS developer tools and GitHub to create a seamless workflow from code commit to deployment.

The process is as follows:

Commit: A developer pushes a change to a feature branch or merges to main in the GitHub repository.

Trigger: The push event triggers AWS CodePipeline.

Source: CodePipeline fetches the latest source code from GitHub.

Build & Test: The pipeline starts an AWS CodeBuild project, which executes a series of commands defined in the buildspec.yml file. This includes:

Initializing Terraform.

Validating syntax (validate) and formatting (fmt).

Running security scans using checkov.

Executing unit, integration, and end-to-end tests using the terraform test framework.

## Deploy:

For Pull Requests/Feature Branches: The build runs a terraform plan to show a dry-run of the changes.

For the main Branch: The build proceeds to run terraform apply to deploy the changes automatically.

## Key Features ✨
Automated Testing: Leverages the native terraform test command to run integration and end-to-end tests against your modules.

Security Scanning: Integrates checkov to scan for infrastructure-as-code misconfigurations and security issues.

Conditional Deployment: Safely runs terraform plan for feature branches and only runs terraform apply on the main branch.

Remote State Management: Uses an S3 bucket for secure, centralized state storage and a DynamoDB table for state locking to prevent concurrent modifications.

Infrastructure as Code (IaC): The entire CI/CD pipeline itself is defined as code using Terraform.

## Technologies Used:
Terraform: For defining both the end-user infrastructure and the pipeline itself.

AWS CodePipeline: The orchestrator for the CI/CD workflow.

AWS CodeBuild: The build server that runs all Terraform commands.

Amazon S3: For storing the Terraform remote state and pipeline artifacts.

Amazon DynamoDB: For managing Terraform state locks.

AWS IAM: For providing secure, least-privilege permissions to the pipeline components.

GitHub: As the source control repository.

Directory Structure
.
├── modules/           
├── tests/              
├── backend.tf         
├── codepipeline.tf     
├── buildspec.yml
└── README.md          
🚀 Getting Started: Setup and Deployment
To deploy this CI/CD pipeline, you need to bootstrap it once from your local machine. After that, the pipeline will manage itself.

## Prerequisites:
An AWS Account
Terraform CLI installed locally.
AWS CLI configured with appropriate credentials.
A GitHub repository containing your Terraform code.

## Step 1: Configure the Backend
In the backend.tf file, change the bucket name to a globally unique name for your S3 bucket.

## Terraform 

# backend.tf
terraform {
  backend "s3" {
    bucket = "your-unique-terraform-state-bucket-name" # 
    # ...
  }
}

## Step 2: Set Up GitHub Connection
In the AWS Console, navigate to Developer Tools > CodePipeline > Settings > Connections.

Click Create connection, select GitHub, and follow the prompts to authorize access to your GitHub account or organization.

Once the connection is created, copy its ARN.

In the codepipeline.tf file, paste the ARN into the ConnectionArn configuration. Also, update the FullRepositoryId to match your username/repo.

# codepipeline.tf
resource "aws_codepipeline" "pipeline" {
  # ...
  stage {
    name = "Source"
    action {
      # ...
      configuration = {
        ConnectionArn    = "arn:aws:codestar-connections:..." # <-- PASTE ARN HERE
        FullRepositoryId = "YourUsername/YourRepoName"     # <-- UPDATE THIS
        BranchName       = "main"
      }
    }
  }
  # ...
} 

## Step 3: Deploy the Pipeline
From your terminal, run the following commands to create the S3 bucket, DynamoDB table, and the CodePipeline itself.

# Initialize Terraform to download providers and configure the backend
terraform init

# Apply the configuration to create the CI/CD pipeline
terraform apply
After you confirm the apply, your automated pipeline will be live!

## How the Pipeline Works:

The core logic resides in the buildspec.yml file, which orchestrates the build process in distinct phases.

install: Installs checkov, our security scanning tool.

pre_build: Runs terraform init to prepare the environment.

##  build:

Runs terraform validate and terraform fmt for basic sanity checks.

Runs checkov to find security vulnerabilities.

Executes terraform test to validate module functionality against the tests defined in the tests/ directory.

## post_build:

This phase contains the conditional logic. 
It inspects the CODEBUILD_WEBHOOK_HEAD_REF environment variable provided by CodeBuild.

If it matches refs/heads/main, it means the build was triggered by a commit to the main branch
and terraform apply -auto-approve is executed.

Otherwise, it's a pull request or feature branch, so it safely runs terraform plan for a dry-run.
