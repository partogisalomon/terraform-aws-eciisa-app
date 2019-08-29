output "private_ip" {
  description = "The private IP of the EC2"
  value       = "${aws_instance.eciisa-app.private_ip}"
}

output "s3_bucket" {
  description = "The S3 bucket name"
  value       = "${module.s3_name.name}"
}

output "datadog_dashboard" {
  description = "The datadog dashboard"
  value = "${module.system.timeboard_title}"
}