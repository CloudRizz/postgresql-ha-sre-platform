# Retrieves the current Ubuntu 24.04 LTS x86_64 AMI published by Canonical.
data "aws_ssm_parameter" "ubuntu_ami" {
  name = "/aws/service/canonical/ubuntu/server/24.04/stable/current/amd64/hvm/ebs-gp3/ami-id"
}

# Allows EC2 instances to assume the shared cluster node IAM role.
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

# Creates the IAM role used by cluster EC2 nodes.
resource "aws_iam_role" "node" {
  name               = "${var.name_prefix}-node-role"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json
}

# Grants cluster nodes the permissions required by AWS Systems Manager.
resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.node.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# Creates the instance profile used to attach the IAM role to cluster EC2 nodes.
resource "aws_iam_instance_profile" "node" {
  name = "${var.name_prefix}-node-profile"
  role = aws_iam_role.node.name
}

# Creates one private PostgreSQL node in each availability zone.
resource "aws_instance" "postgres" {
  for_each = local.postgres_nodes

  ami                    = data.aws_ssm_parameter.ubuntu_ami.value
  instance_type          = var.instance_type
  subnet_id              = var.private_subnet_ids[each.value]
  vpc_security_group_ids = [var.security_group_id]
  iam_instance_profile   = aws_iam_instance_profile.node.name

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
    Etcd = "true"
  }
}

# Creates the dedicated third etcd member required for a three-voter quorum.
resource "aws_instance" "etcd" {
  ami                    = data.aws_ssm_parameter.ubuntu_ami.value
  instance_type          = var.etcd_instance_type
  subnet_id              = var.private_subnet_ids[var.availability_zones[0]]
  vpc_security_group_ids = [var.etcd_security_group_id]
  iam_instance_profile   = aws_iam_instance_profile.node.name

  associate_public_ip_address = false

  # Requires secure Instance Metadata Service version 2 access.
  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  # Encrypts the dedicated etcd node root volume.
  root_block_device {
    volume_type = "gp3"
    volume_size = 8
    encrypted   = true
  }

  tags = {
    Name = "${var.name_prefix}-etcd-03"
    Role = "Etcd"
    Etcd = "true"
  }
}
