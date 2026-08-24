###### vpc ####
resource "aws_vpc" "ahmed-network" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "ahmed-network"
  }

}
###### public subnets #####
resource "aws_subnet" "public-1a" {
  vpc_id            = aws_vpc.ahmed-network.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-northeast-3a"

  tags = {
    Name = "supplier-public-1a"
  }

}
resource "aws_subnet" "public-1b" {
  vpc_id            = aws_vpc.ahmed-network.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "ap-northeast-3b"

  tags = {
    Name = "supplier-public-1b"

  }
  ###### private subnets #####
}
resource "aws_subnet" "private-1a" {
  vpc_id            = aws_vpc.ahmed-network.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "ap-northeast-3a"
  tags = {
    Name = "supplier-private-subnet-1a"
  }

}
resource "aws_subnet" "private-1b" {
  vpc_id            = aws_vpc.ahmed-network.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "ap-northeast-3b"

  tags = {
    Name = "supplier-private-subnet-1b"
  }

}
##### internet gateway #####
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.ahmed-network.id

  tags = {
    Name = "igw"
  }
}
#### route table ####
resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.ahmed-network.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "supplier-public-rt"
  }
}
resource "aws_route_table_association" "public-1a" {
  subnet_id      = aws_subnet.public-1a.id
  route_table_id = aws_route_table.public-rt.id

}
resource "aws_route_table_association" "public-1b" {
  subnet_id      = aws_subnet.public-1b.id
  route_table_id = aws_route_table.public-rt.id

}
resource "aws_nat_gateway" "nat-gateway" {
  subnet_id     = aws_subnet.public-1a.id
  allocation_id = aws_eip.aws_eip.id
  tags = {
    Name = "supplier-nat-gateway"
  }
}
resource "aws_eip" "aws_eip" {
  domain = "vpc"

  tags = {
    Name = "supplier-nat-eip"
  }
}
resource "aws_route_table" "private-rt" {
  vpc_id = aws_vpc.ahmed-network.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-gateway.id

  }

  tags = {
    Name = "supplier-private-rt"
  }
}
resource "aws_route_table_association" "private-1a" {
  subnet_id      = aws_subnet.private-1a.id
  route_table_id = aws_route_table.private-rt.id



}
resource "aws_route_table_association" "private-1b" {
  subnet_id      = aws_subnet.private-1b.id
  route_table_id = aws_route_table.private-rt.id

}