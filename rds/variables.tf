variable "rds_instance_name" {
  description = "Name to be used on the rds instance"
  type        = string
}

variable "vpc_cidr_block" {
  description = "The VPC CIDR block to allow"
  type        = string
  default     = "10.30.0.0/16"
}

variable "tags" {
  description = "Additional tags for the RDS"
  type        = any
  default     = {}
}

variable "private_subnets" {
  description = "Private subnets specification"
  type        = list(any)
  default = []
}

variable "vpc_id" {
  description = "The VPC ID"
  type = string
  default = ""
}

variable "db_engine_version" {
  description = "Database Engine version"
  type = string
  default = "11.10"
}

variable "db_family" {
  description = "Database family"
  type = string
  default = "postgres11"
}

variable "db_major_engine_version" {
  description = "Database Major Engine version"
  type = string
  default = "11"
}

variable "db_instance_flavor" {
  description = "Database instance flavor"
  type = string
  default = "db.t3.small"
}

variable "db_allocated_storage" {
  description = "Database storage to allocate"
  type = number
  default = 60
}

variable "db_max_allocated_storage" {
  description = "Database max storage to allocate"
  type = number
  default = 200
}

variable "db_storage_encrypted" {
  description = "Encrypt db?"
  type = bool
  default = false
}

variable "db_instance_name" {
  description = "RDS name"
  type = string
  default = "postgresql"
}

variable "db_user" {
  description = "Database user"
  type = string
  default = "postgres"
}

variable "db_password" {
  description = "Database password"
  type = string
  default = "MyS0H4rdP@ssw0rdTh4tC4ntB3H4ck3d"
}

variable "db_multi_az" {
  description = "Multi AZ RDS instance?"
  type = bool
  default = false
}

variable "db_subnets" {
  description = "Subnets to put database on"
  type = string
  default = ""
}

variable "db_backup_retention_period" {
  description = "Backup retention value"
  type = number
  default = 0
}

variable "db_skip_final_snapshot" {
  description = "Skip final snapshot from RDS"
  type = bool
  default = true
}

variable "db_deletion_protection" {
  description = "Enable deletion protection?"
  type = bool
  default = true
}

variable "db_performance_insights_enabled" {
  description = "Enable rds performance insights"
  type = bool
  default = true  
}

variable "db_performance_insights_retention_period" {
  description = "Performance insights retention period"
  type = number
  default = 7
}

variable "db_create_monitoring_role" {
  description = "Create IAM role for monitoring?"
  type = bool
  default = true
}
