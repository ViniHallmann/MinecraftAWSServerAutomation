data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
resource "aws_instance" "minecraft_server" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  key_name               = var.key_name
  subnet_id              = aws_subnet.minecraft_public_subnet.id
  vpc_security_group_ids = [aws_security_group.minecraft_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.minecraft_profile.name

  root_block_device {
    volume_size = var.root_volume_size
    volume_type = "gp3"
    encrypted   = true
    tags = {
      Name = "minecraft-root-volume"
    }
  }
  tags = {
    Name = var.instance_name
  }

  #depends_on = [aws_s3_bucket.minecraft_backup]
}

#CLAUDE ME DEU ESSE USER_DATA PARA INSTALACAO DO MINECRAFT, DA PRA USAR ISSO PRA AUTOMATIZAR MAIS AINDA MAS VOU FAZER ESSA PARTE MANUALMENTE!
# User data script to install Java, create minecraft user, and setup a basic Minecraft server
#   user_data = <<-EOF
#               #!/bin/bash
#               yum update -y
#               yum install -y java-17-amazon-corretto
#               yum install -y jq wget

#               # Create minecraft user
#               useradd -r -m -U -d /opt/minecraft minecraft
              
#               # Create directories
#               mkdir -p /opt/minecraft/server
#               mkdir -p /opt/minecraft/backups
              
#               # Mount the EBS data volume
#               mkfs -t xfs /dev/xvdf
#               echo "/dev/xvdf /opt/minecraft/server xfs defaults 0 0" >> /etc/fstab
#               mount -a
              
#               # Change ownership
#               chown -R minecraft:minecraft /opt/minecraft

#               # Switch to minecraft user and download server
#               su - minecraft -c "cd /opt/minecraft/server && \
#                 wget https://piston-data.mojang.com/v1/objects/8dd1a28015f51b1803213892b50b7b4fc76e594d/server.jar -O minecraft_server.jar && \
#                 echo 'eula=true' > eula.txt"
              
#               # Create a systemd service file for Minecraft
#               cat > /etc/systemd/system/minecraft.service << 'MCSVC'
#               [Unit]
#               Description=Minecraft Server
#               After=network.target
              
#               [Service]
#               User=minecraft
#               Group=minecraft
#               WorkingDirectory=/opt/minecraft/server
#               ExecStart=/usr/bin/java -Xmx3G -Xms1G -jar minecraft_server.jar nogui
#               ExecStop=/usr/bin/jq -r '.players[].name' /opt/minecraft/server/usercache.json | xargs -I % /usr/bin/screen -S minecraft -p 0 -X stuff "say Server shutting down in 10 seconds!^M"
#               ExecStop=/bin/sleep 10
#               ExecStop=/usr/bin/screen -S minecraft -p 0 -X stuff "save-all^M"
#               ExecStop=/usr/bin/screen -S minecraft -p 0 -X stuff "stop^M"
#               Restart=on-failure
              
#               [Install]
#               WantedBy=multi-user.target
#               MCSVC
              
#               # Create backup script
#               cat > /opt/minecraft/backup.sh << 'BACKUP'
#               #!/bin/bash
#               # Get the current date
#               DATE=$(date +%Y-%m-%d-%H%M)
              
#               # Directory to back up
#               MCDIR="/opt/minecraft/server"
              
#               # Backup directory
#               BACKUPDIR="/opt/minecraft/backups"
              
#               # S3 bucket
#               S3BUCKET="${aws_s3_bucket.minecraft_backup.id}"
              
#               # Inform players
#               # screen -S minecraft -p 0 -X stuff "say Starting server backup...^M"
              
#               # Save the current world to disk
#               # screen -S minecraft -p 0 -X stuff "save-all^M"
#               # sleep 10
              
#               # Create the backup
#               tar -czf "$BACKUPDIR/minecraft-backup-$DATE.tar.gz" -C "$MCDIR" .
              
#               # Upload to S3
#               aws s3 cp "$BACKUPDIR/minecraft-backup-$DATE.tar.gz" "s3://$S3BUCKET/"
              
#               # Clean up local backup
#               find "$BACKUPDIR" -name "minecraft-backup-*.tar.gz" -mtime +7 -delete
#               BACKUP
              
#               chmod +x /opt/minecraft/backup.sh
#               chown minecraft:minecraft /opt/minecraft/backup.sh
              
#               # Add backup to crontab
#               echo "0 3 * * * /opt/minecraft/backup.sh" > /tmp/minecraft-cron
#               crontab -u minecraft /tmp/minecraft-cron
#               rm /tmp/minecraft-cron
              
#               # Enable and start the service
#               systemctl enable minecraft.service
#               systemctl start minecraft.service
#               EOF