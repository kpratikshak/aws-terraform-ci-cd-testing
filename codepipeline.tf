2\. CI/CD Pipeline Definition (`codepipeline.tf`)

This script provisions the core components of your pipeline: an IAM Role for CodeBuild, the CodeBuild project itself, and the CodePipeline that orchestrates the workflow from GitHub.

```terraform
# codepipeline.tf - Defines the AWS CodePipeline and CodeBuild resources

# IAM Role for CodeBuild to allow it to interact with AWS services
resource "aws_iam_role" "codebuild_role" {
  name = "terraform-cicd-codebuild-role"
  assume_role_policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [{
      Action    = "sts:AssumeRole",
      Effect    = "Allow",
      Principal = {
        Service = "codebuild.amazonaws.com"
      }
    }]
  })
}
