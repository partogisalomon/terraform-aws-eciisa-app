locals {
  eciisa_token_name = "/tvlk-secret/shared/eci/eciisa/agent.token"
  eciisa_token_desc = "Informatica Secure Agent token"
  product_domain    = "eci"
  environment       = "${var.environment}"
}