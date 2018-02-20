#creating a vpc
resource "aws_vpc" "InfraEng_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
  
   tags {
    Name = "main"
  }
}

#creating public and private subnets:

resource "aws_subnet" "public_subnet_1" {
  vpc_id                    =  "${aws_vpc.InfraEng_vpc.id}"
  cidr_block                = "10.0.0.0/24"
  availability_zone         = "us-east-1a"
  map_public_ip_on_launch   = false

  tags {
    Name = "Public_subnet"
  }
}


resource "aws_subnet" "private_subnet_1" {
  vpc_id                    =  "${aws_vpc.InfraEng_vpc.id}"
  cidr_block                = "10.0.1.0/24"
  availability_zone         = "us-east-1b"
  map_public_ip_on_launch   = false

  tags {
    Name = "Private_subnet"
  }
}


#creating Internet gateway
resource "aws_internet_gateway" "InfraEng_InternetGW" {
  vpc_id = "${aws_vpc.InfraEng_vpc.id}"

  tags {
    Name = "main"
  }
}

#creating public and private route tables and associate with them respectively
resource "aws_route_table" "public_route_table" {
  vpc_id = "${aws_vpc.InfraEng_vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.InfraEng_InternetGW.id}"
  }

  # route {
  #   ipv6_cidr_block = "::/0"
  #   egress_only_gateway_id = "${aws_internet_gateway.InfraEng_InternetGW.id}"
  # }

  tags {
    Name = "public_route_table  "
  }
}


#public rout table association:
resource "aws_route_table_association" "public_subnet_association" {
  subnet_id      = "${aws_subnet.public_subnet_1.id}"
  route_table_id = "${aws_route_table.public_route_table.id}"
}


#create nat gateway and public EIP
resource "aws_eip" "InfraEngEIP" {
  vpc = true
}

resource "aws_nat_gateway" "InfraEngNATGW" {
  allocation_id = "${aws_eip.InfraEngEIP.id}"
  subnet_id     = "${aws_subnet.public_subnet_1.id}"
}

#create private rout table with nat gateway:

resource "aws_route_table" "private_route_table" {
  vpc_id = "${aws_vpc.InfraEng_vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_nat_gateway.InfraEngNATGW.id}"
  }

  # route {
  #   ipv6_cidr_block = "::/0"
  #   egress_only_gateway_id = "${aws_internet_gateway.main.id}"
  # }

  tags {
    Name = "public_route_table  "
  }
}


#Private route table association:
resource "aws_route_table_association" "private_subnet_association" {
  subnet_id      = "${aws_subnet.private_subnet_1.id}"
  route_table_id = "${aws_route_table.private_route_table.id}"
}