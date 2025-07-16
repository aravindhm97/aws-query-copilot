variable "aws_region" {
  type    = string
  default = "ap-south-1"
}

variable "project_name" {
  type    = string
  default = "query-copilot"
}

variable "bucket_name" {
  type    = string
  default = "querycopilot-demo-datalake"
}

variable "athena_output_prefix" {
  type    = string
  default = "athena_results/"
}

variable "glue_db_name" {
  type    = string
  default = "copilot_db"
}

variable "glue_table_name" {
  type    = string
  default = "events"
}
