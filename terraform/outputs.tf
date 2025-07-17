output "s3_bucket_name" {
  value = aws_s3_bucket.querycopilot_bucket.bucket
}

output "athena_database_name" {
  value = aws_glue_catalog_database.copilot_db.name
}

output "athena_workgroup_name" {
  value = aws_athena_workgroup.copilot_workgroup.name
}

output "athena_output_location" {
  value = var.athena_output_location
}