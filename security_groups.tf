resource "aws_security_group" "ec2_sg" {
  name        = "ec2-sg"
  description = "Security group for EC2 instances"
  vpc_id      = aws_vpc.custom_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
	cidr_blocks = ["10.0.1.0/24", "10.0.2.0/24"]
	description = "Enables HTTP port"
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
	cidr_blocks = ["10.0.0.1/32"]
	description = "Enables SSH port"
  }
}
resource "aws_default_security_group" "default" {
	vpc_id = aws_vpc.issue_vpc.id
}