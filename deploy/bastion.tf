data "aws_ami" "amazon_linux" {
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-2.0.*-x86_64-gp2"]
  }
  owners = ["amazon"]
}

resource "aws_iam_instance_profile" "bastion" {
  name = "${local.prefix}-bastion-instance-profile"
  # Sainsburys' Account/roles/ssm-ec2-role - contains: AmazonSSMManagedInstanceCore
  role = "ssm-ec2-role"
}

resource "aws_instance" "bastion" {
  ami                  = data.aws_ami.amazon_linux.id
  instance_type        = "t2.micro"
  user_data            = file("./templates/bastion/user-data.sh")
  iam_instance_profile = aws_iam_instance_profile.bastion.name
  # AcademySharedInfraStack/SainsburysSharedVpc/publicSubnet1
  subnet_id = "subnet-0d4860b711cb576a7"

  vpc_security_group_ids = [
    aws_security_group.bastion.id
  ]

  tags = merge(
    local.common_tags,
    tomap({ "Name" = "${local.prefix}-bastion" })
  )
}

resource "aws_security_group" "bastion" {
  description = "Control bastion inbound and outbound access"
  name        = "${local.prefix}-bastion"
  # AcademySharedInfraStack/SainsburysSharedVpc
  vpc_id = "vpc-0e296a5c8aac14d8c"

  egress {
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 5432
    to_port   = 5432
    protocol  = "tcp"
    cidr_blocks = [
      # AcademySharedInfraStack/SainsburysSharedVpc/privateSubnet1 CIDR
      "10.0.12.0/22",
      # AcademySharedInfraStack/SainsburysSharedVpc/privateSubnet2 CIDR
      "10.0.16.0/22",
    ]
  }

  tags = local.common_tags
}
