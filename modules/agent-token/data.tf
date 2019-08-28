data "terraform_remote_state" "tvlk_ssm_tvlk_secret" {
  backend = "s3"

  config {
    bucket = "default-terraform-state-ap-southeast-1-105676898724"
    key    = "ap-southeast-1/general/kms/tvlk-ssm-tvlk-secret/terraform.tfstate"
    region = "ap-southeast-1"
  }
}