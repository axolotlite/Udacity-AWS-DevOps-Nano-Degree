
resource "aws_route_table" "main_rt" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main-igw.id
  }
}
resource "aws_route_table_association" "pub0_rt_ass" {
  subnet_id      = aws_subnet.pub0.id
  route_table_id = aws_route_table.main_rt.id
}
resource "aws_route_table_association" "pub1_rt_ass" {
  subnet_id      = aws_subnet.pub1.id
  route_table_id = aws_route_table.main_rt.id
}

resource "aws_route_table" "priv0_rt" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.pub0-gw.id
  }
}
resource "aws_route_table_association" "priv0_rt_ass" {
  subnet_id      = aws_subnet.priv0.id
  route_table_id = aws_route_table.priv0_rt.id
}
resource "aws_route_table" "priv1_rt" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.pub1-gw.id
  }
}
resource "aws_route_table_association" "priv1_rt_ass" {
  subnet_id      = aws_subnet.priv1.id
  route_table_id = aws_route_table.priv1_rt.id
}

