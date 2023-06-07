
resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
  
  tags= {
    Name = "github-eks"
  }
}

resource "aws_security_group" "my_sg" {
  name        = "my-github-group"
  description = "My Security Group"
  vpc_id      = aws_vpc.my_vpc.id

  # Define your security group rules here
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id
  
  tags = {
    Name = "github-actions-ig"
  }
}

module "eks_cluster" {
  source = "terraform-aws-modules/eks/aws"

  cluster_name           = "github-eks-cluster-1"
  cluster_version        = "1.23"
  vpc_id                 = aws_vpc.my_vpc.id
  subnet_ids             = [aws_subnet.my_subnet.id]
 
  tags = {
    Environment = "development"
  }
}

resource "aws_subnet" "my_subnet" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-south-1a"
  
  tags = {
    Name = "github-actions-sb1"
  }
}
resource "aws_subnet" "my_subnet" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-south-1b"
  
  tags = {
    Name = "github-actions-sb2"
  }
}  
