provider "aws" {
  region = "ap-southeast-1"
}

provider "datadog" {
  api_key = "${data.aws_ssm_parameter.datadog_api_key.value}"
  app_key = "${data.aws_ssm_parameter.datadog_app_key.value}"
}
