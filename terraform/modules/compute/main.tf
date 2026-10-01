# Retrieves the current Ubuntu 24.04 LTS x86_64 AMI published by Canonical.
data "aws_ssm_parameter" "ubuntu_ami" {
  name = "/aws/service/canonical/ubuntu/server/24.04/stable/current/amd64/hvm/ebs-gp3/ami-id"
}

# Allows EC2 instances to assume the PostgreSQL node IAM role.
data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

# Creates the IAM role used by PostgreSQL EC2 nodes.
resource "aws_iam_role" "postgres" {
  name               = "${var.name_prefix}-postgres-role"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json
}

# Grants PostgreSQL nodes the permissions required by AWS Systems Manager.
resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.postgres.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# Creates the instance profile used to attach the IAM role to EC2 instances.
resource "aws_iam_instance_profile" "postgres" {
  name = "${var.name_prefix}-postgres-profile"
  role = aws_iam_role.postgres.name
}

# Creates one private PostgreSQL node in each availability zone.
resource "aws_instance" "postgres" {
  for_each = local.postgres_nodes

  ami                    = data.aws_ssm_parameter.ubuntu_ami.value
  instance_type          = var.instance_type
  subnet_id              = var.private_subnet_ids[each.value]
  vpc_security_group_ids = [var.security_group_id]
  iam_instance_profile   = aws_iam_instance_profile.postgres.name

  associate_public_ip_address = false

  # Requires secure Instance Metadata Service version 2 access.
  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  # Encrypts the PostgreSQL node root volume.
  root_block_device {
    volume_type = "gp3"
    volume_size = 12
    encrypted   = true
  }

  tags = {
    Name = "${var.name_prefix}-${each.key}"
    Role = "PostgreSQL"
  }
}
