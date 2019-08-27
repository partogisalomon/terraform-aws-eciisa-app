# terraform-aws-eciisa-app

Terraform stack module which creates resources for eciisa-app (Informatica Secure Agent for Anaplan)


# Requirements

Existing EC2 Oracle Application Server

Existing VPC

Existing subnets (Private and App)


# Below resources will be created

1 new role for eciisa

1 EC2 for Application

Informatica Secure Agent token

S3 bucket to store data from and to eciisa-app

Security group for Application

Datadog dashboard and monitor
