##################
# eciisa role
##################
module "eciisa_role" {
  source = "github.com/traveloka/terraform-aws-iam-role.git//modules/instance?ref=v1.0.2"

  service_name   = "${local.service_name}"
  cluster_role   = "${local.service_role}"
  product_domain = "${local.product_domain}"
  environment    = "${local.environment}"
}

##################
# EC2 eciisa
##################
resource "aws_instance" "eciisa-app" {
  ami                    = "${local.ami_id}"
  instance_type          = "${local.instance_type}"
  iam_instance_profile   = "${module.eciisa_role.instance_profile_name}"
  subnet_id              = "${local.subnet_id}"
  vpc_security_group_ids = ["${aws_security_group.eciisa-app.id}"]
  user_data_base64       = "${base64encode(local.instance_userdata)}"

  root_block_device {
    volume_type           = "gp2"
    volume_size           = "${local.root_volume_size}"
    delete_on_termination = "true"
  }

  tags {
    Service       = "${local.service_name}"
    Cluster       = "${local.service_name}-${local.service_role}"
    ProductDomain = "${local.product_domain}"
    Application   = "${local.application}"
    Environment   = "${local.environment}"
    Description   = "${local.description}"
    Name          = "${local.service_name}-${local.service_role}-01"
  }
}

##################
# S3 bucket
##################
module "s3_name" {
  source        = "github.com/traveloka/terraform-aws-resource-naming.git?ref=v0.13.0"
  name_prefix   = "${local.service_name}-${data.aws_region.current.name}-${data.aws_caller_identity.current.account_id}"
  resource_type = "s3_bucket"
}

resource "aws_s3_bucket" "bucket" {
  bucket = "${module.s3_name.name}"
  acl    = "private"
}

resource "aws_s3_bucket_policy" "b" {
  bucket = "${aws_s3_bucket.bucket.id}"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowPutObject",
      "Effect": "Allow",
      "Principal": {
        "AWS": "${data.aws_iam_role.oebs_app_profile.arn}"
      },
      "Action": [
        "s3:PutObject"
      ],
      "Resource": "${aws_s3_bucket.bucket.arn}/*"
    },
    {
      "Sid": "AllowReadWrite",
      "Effect": "Allow",
      "Principal": {
        "AWS": "${data.aws_iam_role.eciisa_app_profile.arn}"
      },
      "Action": [
        "s3:DeleteObject",
        "s3:GetObject",
        "s3:PutObject"
      ],
      "Resource": [
        "${aws_s3_bucket.bucket.arn}/*"
      ]
    },
    {
      "Sid": "AllowGetBucket",
      "Effect": "Allow",
      "Principal": {
         "AWS": "${data.aws_iam_role.eciisa_app_profile.arn}"
      },
      "Action": [
         "s3:GetBucketPolicy",
         "s3:GetBucketAcl"
      ],
      "Resource": [
         "${aws_s3_bucket.bucket.arn}"
      ]
    },
    {
      "Sid": "AllowListBucket",
      "Effect": "Allow",
      "Principal": {
        "AWS" : [
            "${data.aws_iam_role.eciisa_app_profile.arn}",
            "${data.aws_iam_role.oebs_app_profile.arn}"
        ]
      },
      "Action": [
        "s3:ListBucket"
      ],
      "Resource": [
        "${aws_s3_bucket.bucket.arn}"
      ]
    }
  ]
}
POLICY
}

##################
# Security Group
##################
module "aws-resource-naming_sg_eciisa-app" {
  source        = "github.com/traveloka/terraform-aws-resource-naming?ref=v0.13.0"
  name_prefix   = "${local.service_name}-${local.service_role}"
  resource_type = "security_group"
}

resource "aws_security_group" "eciisa-app" {
  name        = "${module.aws-resource-naming_sg_eciisa-app.name}"
  description = "${local.service_name}-${local.service_role} security group"
  vpc_id      = "${local.vpc_id}"

  tags {
    Name          = "${module.aws-resource-naming_sg_eciisa-app.name}"
    Cluster       = "${local.service_name}-${local.service_role}"
    Environment   = "${local.environment}"
    ProductDomain = "${local.product_domain}"
    ManagedBy     = "terraform"
    keep_alive    = "true"
  }
}

resource "aws_security_group_rule" "eciisa-app-egress" {
  type              = "egress"
  from_port         = "${local.app_service_port}"
  to_port           = "${local.app_service_port}"
  protocol          = "tcp"
  security_group_id = "${aws_security_group.eciisa-app.id}"
  cidr_blocks       = ["0.0.0.0/0"]
}

##################
# Datadog dashboard and monitor
##################
module "system" {
  source = "github.com/traveloka/terraform-datadog-system"

  product_domain = "${local.product_domain}"
  service        = "${local.service_name}"
  cluster        = "${local.service_name}-${local.service_role}"
  environment    = "${local.environment}"

  recipients = ["${local.recipient}"]

  memory_free_thresholds = {
    critical = 1000000000
    warning  = 1500000000
  }

  network_in_thresholds = {
    critical = 30000000
    warning  = 20000000
  }

  network_out_thresholds = {
    critical = 30000000
    warning  = 20000000
  }

  open_file_thresholds = {
    critical = 30000
    warning  = 25000
  }

  system_load_thresholds = {
    critical = 3
    warning  = 2
  }

  disk_device = ""
}
