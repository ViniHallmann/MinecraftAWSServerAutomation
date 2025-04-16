resource "aws_ebs_volume" "minecraft_data" {
  availability_zone = "${var.aws_region}a"
  size              = var.minecraft_data_volume_size
  type              = "gp3"
  encrypted         = true

  tags = {
    Name = "minecraft-data-volume"
  }
}

resource "aws_volume_attachment" "minecraft_data_attachment" {
  device_name = "/dev/xvdf"
  volume_id   = aws_ebs_volume.minecraft_data.id
  instance_id = aws_instance.minecraft_server.id
  stop_instance_before_detaching = true
}
