# Terraform CI/CD Testing on AWS

Statement: Manual terraform deployments lack of testing and increase risk of misconfigured infrasturcture,security issues and unscalable cloud environments. This pipeline solves that by building a CI/CD System that automates testing and deployment of Terraform modules.

Cloud Architecture:
Technologies:
Terraform
AWS Codepipeline 
AWS CodeBuild
S3
DynamoDB
IAM
Github

Structure:
Testing pipeline(module validation)
Deployment pipeline
Remote State setup across two pipeline
Refactored out codecommit replaced with Github 

Implemantation:
Developed a reusable terraform module to provision AWS Infra using Iac Best practices ,including IAM Roles,S3 Buckets and codepipeline.

2.Integrated Terraform test framework to validate module functionality with unit,IntegraCon and end-to-end tests.


DynamoDB -state lock management
AWS CodeBuild: Executes Terraform tests,checkiv scans and apply

Technical Implementation:
    Developed a reusable terraform module to provision AWS Infra using Iac best practices,including IAM Roles,S3 Buckets and codepipeline.

Integrated terraform test framework to validate module functionality with unit, integracon and end-to-end tests.
  -reusing previous version of hashicorp/aws from the dependency lock file
  -reusing previous of hashicorp/random from the dependency lock file
Using previous installed  hashicorp/random file

terraform test
run "input_validation" aws
run "e2e_test" ... pass
run "e2s_test"... pass
tests/main.tftest.hcl ...tearing down
tests/main.tftest.hcl ...pass



