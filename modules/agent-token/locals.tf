locals {
  eciisa_token_name = "/tvlk-secret/shared/eci/eciisa/eciisa-app/eciisa-app-token/agent_token.key"
  eciisa_token_desc = "Informatica Secure Agent token"
  product_domain    = "eci"
  environment       = "${var.environment}"
}