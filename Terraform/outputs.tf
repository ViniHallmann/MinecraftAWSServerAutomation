output "minecraft_server_public_ip" {
  description = "Public IP address of the Minecraft server"
  value       = aws_instance.minecraft_server.public_ip
}

output "minecraft_connection_info" {
  description = "Minecraft server connection information"
  value       = "Connect to the Minecraft server using the IP: ${aws_instance.minecraft_server.public_ip}:${var.minecraft_port}"
}

output "ssh_connection_command" {
  description = "Command to SSH into the Minecraft server"
  value       = "ssh -i ~/.ssh/${var.key_name}.pem ec2-user@${aws_instance.minecraft_server.public_ip}"
}