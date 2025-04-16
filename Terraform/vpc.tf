resource "aws_vpc" "minecraft_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "minecraft-vpc"
  }
}

resource "aws_subnet" "minecraft_public_subnet" {
  vpc_id                  = aws_vpc.minecraft_vpc.id
  cidr_block              = var.public_subnet_cidr
  map_public_ip_on_launch = true
  availability_zone       = "${var.aws_region}a"

  tags = {
    Name = "minecraft-public-subnet"
  }
}

resource "aws_internet_gateway" "minecraft_igw" {
  vpc_id = aws_vpc.minecraft_vpc.id

  tags = {
    Name = "minecraft-igw"
  }
}

resource "aws_route_table" "minecraft_public_rt" {
  vpc_id = aws_vpc.minecraft_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.minecraft_igw.id
  }

  tags = {
    Name = "minecraft-public-rt"
  }
}

resource "aws_route_table_association" "minecraft_public_rta" {
  subnet_id      = aws_subnet.minecraft_public_subnet.id
  route_table_id = aws_route_table.minecraft_public_rt.id
}