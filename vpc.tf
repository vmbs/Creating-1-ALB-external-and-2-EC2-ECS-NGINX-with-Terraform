### Network
 
# Internet VPC
 
resource "aws_vpc" "sys-vpc" {
  cidr_block           = "172.21.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  enable_classiclink   = "false"
 
  tags = {
    Name = "sys-vpc"
  }
}
 
# Subnets
resource "aws_subnet" "sys-public-1" {
  vpc_id                  = "${aws_vpc.sys-vpc.id}"
  cidr_block              = "172.21.10.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "eu-central-1a"
 
  tags = {
    Name = "sys-public-1"
  }
}
 
resource "aws_subnet" "sys-public-2" {
  vpc_id                  = "${aws_vpc.sys-vpc.id}"
  cidr_block              = "172.21.20.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "eu-central-1b"
 
  tags = {
    Name = "sys-public-2"
  }
}
 
resource "aws_subnet" "sys-public-3" {
  vpc_id                  = "${aws_vpc.sys-vpc.id}"
  cidr_block              = "172.21.30.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "eu-central-1c"
 
  tags = {
    Name = "sys-public-3"
  }
}
 
resource "aws_subnet" "sys-private-1" {
  vpc_id                  = "${aws_vpc.sys-vpc.id}"
  cidr_block              = "172.21.40.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "eu-central-1a"
 
  tags = {
    Name = "sys-private-1"
  }
}
 
resource "aws_subnet" "sys-private-2" {
  vpc_id                  = "${aws_vpc.sys-vpc.id}"
  cidr_block              = "172.21.50.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "eu-central-1b"
 
  tags = {
    Name = "sys-private-2"
  }
}
 
resource "aws_subnet" "sys-private-3" {
  vpc_id                  = "${aws_vpc.sys-vpc.id}"
  cidr_block              = "172.21.60.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "eu-central-1c"
 
  tags = {
    Name = "sys-private-3"
  }
}
 
# Internet GW 
resource "aws_internet_gateway" "sys-gw" {
  vpc_id = "${aws_vpc.sys-vpc.id}"
 
  tags = {
    Name = "sys-IGW"
  }
}
 
# route tables
resource "aws_route_table" "sys-web-public" {
  vpc_id = "${aws_vpc.sys-vpc.id}"
 
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.sys-gw.id}"
  }
 
  tags = {
    Name = "sys-public-1"
  }
}
 
# route associations public
resource "aws_route_table_association" "sys-public-1-a" {
  subnet_id      = "${aws_subnet.sys-public-1.id}"
  route_table_id = "${aws_route_table.sys-web-public.id}"
}
 
resource "aws_route_table_association" "sys-public-2-a" {
  subnet_id      = "${aws_subnet.sys-public-2.id}"
  route_table_id = "${aws_route_table.sys-web-public.id}"
}
 
resource "aws_route_table_association" "sys-public-3-a" {
  subnet_id      = "${aws_subnet.sys-public-3.id}"
  route_table_id = "${aws_route_table.sys-web-public.id}"
}
