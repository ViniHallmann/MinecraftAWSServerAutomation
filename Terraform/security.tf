resource "aws_security_group" "minecraft_sg" {
  name        = "minecraft-security-group"
  description = "Security group for Minecraft server"
  vpc_id      = aws_vpc.minecraft_vpc.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH"
  }
  ingress {
    from_port   = var.minecraft_port
    to_port     = var.minecraft_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Minecraft Server Port"
  }

  # Outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = {
    Name = "minecraft-sg"
  }
}
resource "aws_iam_role" "minecraft_server_role" {
  name = "minecraft-server-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    Name = "minecraft-server-role"
  }
}
resource "aws_iam_instance_profile" "minecraft_profile" {
  name = "minecraft-instance-profile"
  role = aws_iam_role.minecraft_server_role.name
}
# resource "aws_iam_role_policy" "minecraft_s3_access" {
#   name = "minecraft-s3-access"
#   role = aws_iam_role.minecraft_server_role.id

#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = [
#           "s3:PutObject",
#           "s3:GetObject",
#           "s3:ListBucket",
#           "s3:DeleteObject"
#         ]
#         Effect   = "Allow"
#         Resource = [
#           "arn:aws:s3:::${aws_s3_bucket.minecraft_backup.id}",
#           "arn:aws:s3:::${aws_s3_bucket.minecraft_backup.id}/*"
#         ]
#       },
#     ]
#   })
# }