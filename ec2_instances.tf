resource "aws_instance" "ec2_instance_1" {
  ami           = "ami-052c9ea013e6e3567"
  instance_type = "t2.micro"
  root_block_device {
	encrypted = true
  }
  metadata_options {
	http_endpoint = "enabled"
	http_tokens = "required"
  }
  monitoring = true
  ebs_optimized = true
  subnet_id     = aws_subnet.public_subnet_1.id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update
              sudo apt-get install -y nginx docker.io
              EOF

  tags = {
    Name = "EC2Instance1"
  }
  iam_instance_profile = "test"
}

resource "aws_instance" "ec2_instance_2" {
  ami           = "ami-052c9ea013e6e3567"
  instance_type = "t2.micro"
  root_block_device {
	encrypted = true
  }
  metadata_options {
	http_endpoint = "enabled"
	http_tokens = "required"
  }
  monitoring = true
  ebs_optimized = true
  subnet_id     = aws_subnet.public_subnet_2.id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update
              sudo apt-get install -y nginx docker.io
              EOF

  tags = {
    Name = "EC2Instance2"
  }
  iam_instance_profile = "test"
}
