terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "meridian_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags                 = { Name = "meridian-vpc" }
}

resource "aws_subnet" "meridian_subnet" {
  vpc_id                  = aws_vpc.meridian_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  tags                    = { Name = "meridian-public-subnet" }
}

resource "aws_internet_gateway" "meridian_igw" {
  vpc_id = aws_vpc.meridian_vpc.id
  tags   = { Name = "meridian-igw" }
}

resource "aws_route_table" "meridian_rt" {
  vpc_id = aws_vpc.meridian_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.meridian_igw.id
  }
  tags = { Name = "meridian-route-table" }
}

resource "aws_route_table_association" "meridian_rta" {
  subnet_id      = aws_subnet.meridian_subnet.id
  route_table_id = aws_route_table.meridian_rt.id
}

resource "aws_security_group" "meridian_sg" {
  name        = "meridian-sg"
  description = "Security group for Meridian EC2"
  vpc_id      = aws_vpc.meridian_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "meridian_key" {
  key_name   = "meridian-key"
  public_key = file("meridian_key.pub")
}

resource "aws_instance" "meridian_server" {
  ami           = "ami-0c7217cdde317cfec"
  instance_type = "t3.micro"

  subnet_id              = aws_subnet.meridian_subnet.id
  vpc_security_group_ids = [aws_security_group.meridian_sg.id]
  key_name               = aws_key_pair.meridian_key.key_name

  root_block_device {
    volume_size = 20
    volume_type = "gp3"
  }

  tags = { Name = "meridian-ec2-server" }
}

resource "aws_ecr_repository" "frontend" {
  name                 = "meridian/frontend"
  image_tag_mutability = "IMMUTABLE"
}

resource "aws_ecr_repository" "auth_service" {
  name                 = "meridian/auth-service"
  image_tag_mutability = "IMMUTABLE"
}

resource "aws_ecr_repository" "catalog_service" {
  name                 = "meridian/catalog-service"
  image_tag_mutability = "IMMUTABLE"
}

resource "aws_ecr_repository" "orders_service" {
  name                 = "meridian/orders-service"
  image_tag_mutability = "IMMUTABLE"
}
