output "s3_bucket_name" {
  value = aws_s3_bucket.querycopilot_bucket.bucket
}

output "athena_database_name" {
  value = aws_athena_database.copilot_db.name
}

output "athena_table_name" {
  value = aws_athena_table.copilot_events.name
}

output "athena_output_location" {
  value = aws_s3_bucket.querycopilot_bucket.bucket_regional_domain_name
}