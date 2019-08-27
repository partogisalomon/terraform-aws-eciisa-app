locals {
  region_id         = "ap-southeast-1"
  ami_id            = "ami-055c55112e25b1f1f"
  instance_type     = "c5.xlarge"

  service_name      = "eciisa"
  service_role      = "app"
  application       = "RHEL-7.6_HVM_GA-20190128-x86_64-0-Hourly2-GP2 (ami-055c55112e25b1f1f)"
  description       = "Informatica Secure Agent to connect with Anaplan"
  product_domain    = "eci"
  app_service_port  = 443
  root_volume_size  = 100
  recipient         = "partogi.salomon@traveloka.com"

  environment       = "${var.environment}"
  vpc_id            = "${var.vpc_id}"
  subnet_id         = "${var.subnet_id}"
  oebs_app_profile  = "${var.oebs_app_profile}"

  eciisa_token_name = "/tvlk-secret/shared/eci/eciisa/agent.token"
  eciisa_token_desc = "eciisa token"

  //todo
  eciisa_role_name          = "InstanceRole_eciisa-app-eb1487e0c44b6198"
  eciisa_instance_profile   = "InstanceProfile_eciisa-app-eb1487e0c44b6198"
}