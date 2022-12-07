resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  tags = {
    Name = "Lab7-VPC"
  }
}

resource "aws_subnet" "net1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.0.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "us-east-1a"

  tags = {
    Name = "subnet1a"
  }
}

resource "aws_subnet" "net2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "us-east-1b"

  tags = {
    Name = "subnet2b"
  }
}

resource "aws_internet_gateway" "lab7_gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "Lab7-IGW"
  }
}

resource "aws_route_table" "rt7" {
    vpc_id = aws_vpc.main.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.lab7_gw.id
    }

    tags = {
        Name = "RT_Lab7"
    }
}

resource "aws_route_table_association" "sub1a" {
    subnet_id      = aws_subnet.net1.id
    route_table_id = aws_route_table.rt7.id
}

resource "aws_route_table_association" "sub1b" {
    subnet_id      = aws_subnet.net2.id
    route_table_id = aws_route_table.rt7.id

}

resource "aws_network_acl" "lab7_acl" {
    vpc_id = aws_vpc.main.id

    ingress {
        protocol   = -1
        rule_no    = 100
        action     = "deny"
        cidr_block = "50.31.252.0/24"
        from_port  = 0
        to_port    = 0
    }
}

resource "aws_security_group" "lab7_sg" {
    name   = "Lab7_SG"
    vpc_id = aws_vpc.main.id

    ingress {
        from_port   = 3306
        to_port     = 3306
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = -1
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "Lab7SG"
    }
}

resource "aws_db_subnet_group" "db_sg" {
    name       = "subnet_group"
    subnet_ids = [aws_subnet.net1.id, aws_subnet.net2.id]

    tags = {
        Name = "MySubnetGroup_Lab7"
    }
}
