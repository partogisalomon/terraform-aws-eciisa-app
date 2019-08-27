# terraform-aws-eciisa-app
Terraform stack module which creates resources for eciisa-app (Informatica Secure Agent for Anaplan)

# Requirements

Existing VPC

Existing subnets (Public, App and Data)

# Below resources will be created

1 ec2 for Application

Security group for Application

S3 bucket to store data from and to eciisa-app

IAM role and Policy to access s3 bucket from ec2 instances
