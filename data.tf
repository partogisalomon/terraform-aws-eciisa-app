data "aws_region" "current" {}
data "aws_caller_identity" "current" {
}

data "aws_iam_role" "eciisa_app_profile" {
  //name = "${module.eciisa_role.role_name}"
  //todo
  name = "${local.eciisa_role_name}"
}

data "aws_iam_role" "oebs_app_profile" {
  name = "${local.oebs_app_profile}"
}
