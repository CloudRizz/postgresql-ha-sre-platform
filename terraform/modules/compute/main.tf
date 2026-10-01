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
