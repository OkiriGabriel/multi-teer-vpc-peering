provider "aws" {
  region = "us-east-2"  # Update with your primary AWS region
}

# Create VPC in primary region
resource "aws_vpc" "primary_vpc" {
  cidr_block = "10.0.0.0/16"

  enable_dns_support   = true
  enable_dns_hostnames = true
}

# Create subnet in primary region
resource "aws_subnet" "primary_subnet" {
  vpc_id                  = aws_vpc.primary_vpc.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = "us-east-2a"
  map_public_ip_on_launch = true
}

# Create subnet in primary region
resource "aws_subnet" "secondary_subnet" {
  vpc_id                  = aws_vpc.primary_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-2b"
    map_public_ip_on_launch = true
}


# Create peer VPC in secondary region
resource "aws_vpc" "peer_vpc" {
  cidr_block = "10.1.0.0/16"
   enable_dns_support   = true
  enable_dns_hostnames = true
}


# Create subnet in secondary region
resource "aws_subnet" "peer_subnet" {
  vpc_id                  = aws_vpc.peer_vpc.id
  cidr_block              = "10.1.0.0/24"
  availability_zone       = "us-east-2b"
}

# Create VPC peering connection
resource "aws_vpc_peering_connection" "peering_connection" {
  vpc_id                 = aws_vpc.primary_vpc.id
  peer_vpc_id            = aws_vpc.peer_vpc.id
   auto_accept               = true
#   peer_region            = "us-west-1"  # Update with your secondary AWS region
#   auto_accept            = true

     accepter {
    allow_remote_vpc_dns_resolution = true
  }

  requester {
    allow_remote_vpc_dns_resolution = true
  }
}

# Accept VPC peering connection in secondary region
resource "aws_vpc_peering_connection_accepter" "accepter" {
  vpc_peering_connection_id = aws_vpc_peering_connection.peering_connection.id
  auto_accept               = true
}


resource "aws_vpc_peering_connection_options" "vpc_peering_options" {
  vpc_peering_connection_id = aws_vpc_peering_connection.peering_connection.id

  accepter {
    allow_remote_vpc_dns_resolution = true
  }
}
# Create route tables in each region
resource "aws_route_table" "primary_route_table" {
  vpc_id = aws_vpc.primary_vpc.id
}

resource "aws_route_table" "secondary_route_table" {
  vpc_id = aws_vpc.peer_vpc.id
}

# Create routes for VPC peering in each route table
resource "aws_route" "primary_route" {
  route_table_id         = aws_route_table.primary_route_table.id
  destination_cidr_block = aws_vpc.peer_vpc.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.peering_connection.id
}

resource "aws_route" "secondary_route" {
  route_table_id         = aws_route_table.secondary_route_table.id
  destination_cidr_block = aws_vpc.primary_vpc.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.peering_connection.id
}

# Create EC2 instances in each VPC for demonstration
resource "aws_instance" "primary_instance" {
  ami           = "ami-069d73f3235b535bd"  # Update with desired AMI ID
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.primary_subnet.id

  tags = {
    Name = "Primary Instance"
  }
}

resource "aws_instance" "secondary_instance" {
  ami           = "ami-069d73f3235b535bd"  # Update with desired AMI ID
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.secondary_subnet.id

  tags = {
    Name = "Secondary Instance"
  }
}
