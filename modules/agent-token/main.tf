resource "aws_ssm_parameter" "eciisa_token" {
  name        = "${local.eciisa_token_name}"
  type        = "SecureString"
  value       = "changemeplease"
  description = "${local.eciisa_token_desc}"

  key_id = "${data.terraform_remote_state.tvlk_ssm_tvlk_secret.key_id}"

  tags {
    Description   = "${local.eciisa_token_desc}"
    Environment   = "${local.environment}"
    Name          = "${local.eciisa_token_name}"
    ProductDomain = "${local.product_domain}"
    ManagedBy     = "terraform"
  }

  lifecycle {
      ignore_changes = [
        "value",
      ]
    }
}