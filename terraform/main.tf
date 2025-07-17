provider "aws" {
  region  = "ap-south-1"
  profile = var.aws_profile
}

resource "aws_s3_bucket" "querycopilot_bucket" {
  bucket = var.s3_bucket_name
  force_destroy = true
}

resource "aws_s3_bucket_public_access_block" "querycopilot_block" {
  bucket = aws_s3_bucket.querycopilot_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_glue_catalog_database" "copilot_db" {
  name = var.athena_database_name
}

resource "aws_glue_crawler" "copilot_crawler" {
  name         = "copilot-crawler"
  role         = aws_iam_role.athena_access_role.arn
  database_name = aws_glue_catalog_database.copilot_db.name

  s3_target {
    path = "s3://${aws_s3_bucket.querycopilot_bucket.bucket}/input-data"
  }

  schedule {
    schedule_expression = "cron(0 12 * * ? *)" # daily
  }

  schema_change_policy {
    delete_behavior = "LOG"
    update_behavior = "UPDATE_IN_DATABASE"
  }
}

resource "aws_athena_workgroup" "copilot_workgroup" {
  name = "copilot-workgroup"
  configuration {
    enforce_workgroup_configuration = true
    result_configuration {
      output_location = var.athena_output_location
    }
  }
}

resource "aws_iam_role" "athena_access_role" {
  name = "athena-access-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "glue.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "athena_access_policy" {
  name = "athena-access-policy"
  role = aws_iam_role.athena_access_role.id

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
          "${aws_s3_bucket.querycopilot_bucket.arn}/*",
          "${aws_s3_bucket.querycopilot_bucket.arn}"
        ]
      },
      {
        Effect = "Allow",
        Action = [
          "glue:*",
          "athena:*"
        ],
        Resource = "*"
      }
    ]
  })
}