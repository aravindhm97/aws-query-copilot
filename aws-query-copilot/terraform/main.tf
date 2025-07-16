# main.tf
provider "aws" {
  region = var.aws_region
  profile = var.aws_profile
}

module "s3_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket = var.s3_bucket_name
  acl    = "private"

  versioning = {
    enabled = true
  }

  lifecycle_rule = [
    {
      enabled = true
      expiration = {
        days = 30
      }
    }
  ]

  tags = {
    Project = "aws-query-copilot"
  }
}

resource "aws_iam_role" "athena_exec_role" {
  name = "query-copilot-athena-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Principal = {
          Service = "athena.amazonaws.com"
        },
        Effect = "Allow",
        Sid = ""
      }
    ]
  })
}

resource "aws_iam_role_policy" "athena_exec_policy" {
  name = "query-copilot-athena-policy"
  role = aws_iam_role.athena_exec_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket"
        ],
        Resource = [
          "${module.s3_bucket.bucket_arn}/*",
          module.s3_bucket.bucket_arn
        ]
      },
      {
        Effect = "Allow",
        Action = [
          "athena:*",
          "glue:*"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_glue_catalog_database" "copilot_db" {
  name = var.athena_db_name
}

resource "aws_glue_catalog_table" "events_table" {
  name          = "events"
  database_name = aws_glue_catalog_database.copilot_db.name

  table_type = "EXTERNAL_TABLE"

  parameters = {
    "classification" = "json",
    "compressionType" = "none",
    "typeOfData"      = "file"
  }

  storage_descriptor {
    location      = "s3://${var.s3_bucket_name}/events/"
    input_format  = "org.apache.hadoop.mapred.TextInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"

    ser_de_info {
      name                  = "events"
      serialization_library = "org.openx.data.jsonserde.JsonSerDe"
      parameters = {
        "serialization.format" = "1"
      }
    }

    columns = [
      {
        name = "user_id"
        type = "string"
      },
      {
        name = "event_type"
        type = "string"
      },
      {
        name = "timestamp"
        type = "string"
      }
    ]
  }
}
