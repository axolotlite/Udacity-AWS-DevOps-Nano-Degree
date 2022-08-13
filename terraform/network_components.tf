
resource "aws_vpc" "main" {
  cidr_block = var.cidrs["vpc"]
  tags = {
    Name = "main-vpc"
  }
}
resource "aws_internet_gateway" "main-igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "main-igw"
  }
}

resource "aws_subnet" "priv0" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.cidrs["priv0"]
  availability_zone       = var.availability_zones["az1"]
  map_public_ip_on_launch = false
}
resource "aws_subnet" "priv1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.cidrs["priv1"]
  availability_zone       = var.availability_zones["az2"]
  map_public_ip_on_launch = false
}

resource "aws_subnet" "pub0" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.cidrs["pub0"]
  availability_zone       = var.availability_zones["az1"]
  map_public_ip_on_launch = true
}
resource "aws_eip" "pub0-eip" {
  vpc = true
}
resource "aws_nat_gateway" "pub0-gw" {
  allocation_id = aws_eip.pub0-eip.id
  subnet_id     = aws_subnet.pub0.id
}

resource "aws_subnet" "pub1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.cidrs["pub1"]
  availability_zone       = var.availability_zones["az2"]
  map_public_ip_on_launch = true
}
resource "aws_eip" "pub1-eip" {
  vpc = true
}
resource "aws_nat_gateway" "pub1-gw" {
  allocation_id = aws_eip.pub1-eip.id
  subnet_id     = aws_subnet.pub1.id
}