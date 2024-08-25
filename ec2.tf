# Create a "base" Security Group to be assigned to all EC2 instances
resource "aws_security_group" "sg-base-ec2" {
  vpc_id = aws_vpc.default-vpc.id
}

# DANGEROUS!!
# Allow access from the Internet to port 22 (SSH) in the EC2 instances
resource "aws_security_group_rule" "sr-internet-to-ec2-ssh" {
  security_group_id = aws_security_group.sg-base-ec2.id
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"] # Internet
}

# Allow access from the Internet for ICMP protocol (e.g. ping) to the EC2 instances
resource "aws_security_group_rule" "sr-internet-to-ec2-icmp" {
  security_group_id = aws_security_group.sg-base-ec2.id
  type              = "ingress"
  from_port         = -1
  to_port           = -1
  protocol          = "icmp"
  cidr_blocks       = ["0.0.0.0/0"] # Internet
}

resource "aws_security_group_rule" "sr-internet-to-ec2-all" {
  security_group_id = aws_security_group.sg-base-ec2.id
  type              = "ingress"
  from_port         = -1
  to_port           = -1
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"] # Internet
}

# Allow all outbound traffic to Internet
resource "aws_security_group_rule" "sr-all-outbund" {
  security_group_id = aws_security_group.sg-base-ec2.id
  type              = "egress"
  from_port         = "0"
  to_port           = "0"
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

# Back end server running Ubuntu 22.04 ARM Server.
resource "aws_instance" "ec2-instances" {
  for_each = var.instances

  ami                    = each.value.instance_ami
  instance_type          = each.value.instance_type

  subnet_id              = aws_subnet.subnet-pub-01.id
  key_name               = "infra-dev-services"
  vpc_security_group_ids = [aws_security_group.sg-base-ec2.id]

  ebs_block_device {
    volume_size = each.value.volume_size
    volume_type = "gp3"
    device_name = "/dev/sda1"
    iops = 100
    throughput = 0
  }

  tags = {
    Name           = "instance ${each.value.id} - ${each.value.worker_type} - ${each.value.os_name}"
    "private_name" = "ec2-instance-${each.value.id}-${each.value.worker_type}"
    os_name        = each.value.os_name
    "cost_center"  = "santuu"
    WorkerType     = each.value.worker_type
  }
}
