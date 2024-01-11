provider "aws" {
  region = "us-east-1"
  profile = "default"
}

resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "subnet_1" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
}

resource "aws_security_group" "test_sg" {
  name        = "test_sg"
  description = "Test Security Group for EC2 Instance in VPC"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "-1"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port   = -1
    to_port     = -1
    protocol    = "-1"
    cidr_blocks = ["10.0.0.0/16"]
  }
}

resource "aws_instance" "main" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t3.small"
  subnet_id     = aws_subnet.subnet_1.id
  key_name      = "test_key"
  security_group_names = [aws_security_group.test_sg.name]

  dynamic "ebs_block_device" {
    for_each = {
      "sda1" = 30,
      "sdb"  = 50,
      "sdc"  = 100,
    }

    content {
      device_name = "/dev/${ebs_block_device.key}"
      volume_size = ebs_block_device.value
    }
  }
}
