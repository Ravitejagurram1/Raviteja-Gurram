provider "aws" {
  region = "your_region"
}

resource "aws_vpc" "raviteja_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "raviteja_subnet" {
  vpc_id                  = aws_vpc.raviteja_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "your_az"
}

resource "aws_security_group" "raviteja_security_group" {
  vpc_id = aws_vpc.raviteja_vpc.id

  // Define your security group rules here
}

resource "aws_instance" "raviteja_instance" {
  ami           = "your_ami_id"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.raviteja_subnet.id
  key_name      = "your_key_pair_name"
  security_group_ids = [aws_security_group.raviteja_security_group.id]

  // You can add more configuration for your instance here

  // Attach EBS volumes
  ebs_block_device {
    device_name = "/dev/sdf"
    volume_type = "gp2"
    volume_size = 10
  }

  ebs_block_device {
    device_name = "/dev/sdg"
    volume_type = "gp2"
    volume_size = 20
  }

  ebs_block_device {
    device_name = "/dev/sdh"
    volume_type = "gp2"
    volume_size = 30
  }
}
