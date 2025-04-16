variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "sa-east-1"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block for public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.large"
}

variable "instance_name" {
  description = "Name tag for EC2 instance"
  type        = string
  default     = "minecraft-server"
}

variable "key_name" {
  description = "SSH key pair name"
  type        = string
  default     = "minecraft-server-key-pair"
}

variable "root_volume_size" {
  description = "Size of root volume in GB"
  type        = number
  default     = 20
}

variable "minecraft_data_volume_size" {
  description = "Size of EBS volume for Minecraft data in GB"
  type        = number
  default     = 30
}

variable "minecraft_port" {
  description = "Port for Minecraft server"
  type        = number
  default     = 25565
}
#BACKUP (fazer depois)
# variable "backup_retention_days" {
#   description = "Number of days to retain backups"
#   type        = number
#   default     = 7
# }