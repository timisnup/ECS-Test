#VPC
resource "aws_vpc" "test-vpc" {
  cidr_block           = "10.20.0.0/16"
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "task vpc"
  }
}

#Private subnets
resource "aws_subnet" "private-sub-1" {
  vpc_id            = aws_vpc.test-vpc.id
  cidr_block        = "10.20.30.0/24"
  availability_zone = "eu-west-2a"

  tags = {
    Name = "private sub 1"
  }
}

resource "aws_subnet" "private-sub-2" {
  vpc_id            = aws_vpc.test-vpc.id
  cidr_block        = "10.20.31.0/24"
  availability_zone = "eu-west-2b"

  tags = {
    Name = "private sub 2"
  }
}

#Public subnets 
resource "aws_subnet" "public-sub-1" {
  vpc_id            = aws_vpc.test-vpc.id
  cidr_block        = "10.20.32.0/24"
  availability_zone = "eu-west-2a"

  tags = {
    Name = "public sub 1"
  }
}

resource "aws_subnet" "public-sub-2" {
  vpc_id            = aws_vpc.test-vpc.id
  cidr_block        = "10.20.33.0/24"
  availability_zone = "eu-west-2b"

  tags = {
    Name = "public sub 2"
  }
}


#Allocate Elastic IP Address 1
resource "aws_eip" "eip-for-nat-gateway-1" {
  vpc = true

  tags = {
    Name = "EIP 1"
  }
}

#Allocate Elastic IP Address 2
resource "aws_eip" "eip-for-nat-gateway-2" {
  vpc = true

  tags = {
    Name = "EIP 2"
  }
}

#Create Nat gateway 1 in Public subnet
resource "aws_nat_gateway" "nat-gateway-1" {
  allocation_id = aws_eip.eip-for-nat-gateway-1.id
  subnet_id     = aws_subnet.public-sub-1.id

  tags = {
    Name = "NAT Gateway Public subnet 1"
  }
}


#Create Nat gateway 2 in Public subnet
resource "aws_nat_gateway" "nat-gateway-2" {
  allocation_id = aws_eip.eip-for-nat-gateway-2.id
  subnet_id     = aws_subnet.public-sub-2.id

  tags = {
    Name = "NAT Gateway Public subnet 2"
  }
}

#Public route table
resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.test-vpc.id

  tags = {
    Name = "public Route Table"
  }
}

#Opening Public route to the internet
resource "aws_route" "public-igw-route" {
  route_table_id         = aws_route_table.public-rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id

}


#Private route table
#Create Private Route Table 1 and add route through Nat gatway 1
resource "aws_route_table" "private-rt-1" {
  vpc_id = aws_vpc.test-vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-gateway-1.id
  }

  tags = {
    Name = "private Route Table 1"
  }
}

#Create Private Route Table 2 and add route through Nat gatway 2
resource "aws_route_table" "private-rt-2" {
  vpc_id = aws_vpc.test-vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-gateway-2.id
  }

  tags = {
    Name = "private Route Table 2"
  }
}



#public route table association
resource "aws_route_table_association" "public-rt-1-association" {
  subnet_id      = aws_subnet.public-sub-1.id
  route_table_id = aws_route_table.public-rt.id
}

resource "aws_route_table_association" "public-rt-2-association" {
  subnet_id      = aws_subnet.public-sub-2.id
  route_table_id = aws_route_table.public-rt.id
}

#private route table association
resource "aws_route_table_association" "private-rt-1-association" {
  subnet_id      = aws_subnet.private-sub-1.id
  route_table_id = aws_route_table.private-rt-1.id
}

resource "aws_route_table_association" "private-rt-2-association" {
  subnet_id      = aws_subnet.private-sub-2.id
  route_table_id = aws_route_table.private-rt-2.id
}

#Internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.test-vpc.id

  tags = {
    Name = "igw"
  }
}

