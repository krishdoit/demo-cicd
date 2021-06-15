resource "aws_iam_role" "provisioner-iam-role" {
  name = "provisioner-iam-role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY

}

resource "aws_iam_role_policy_attachment" "provisioner-iam-policyattachment" {
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
  role       = aws_iam_role.provisioner-iam-role.name
}


resource "aws_iam_instance_profile" "provisioner-instance-profile" {
  name = "provisioner-instance-profile"
  role = aws_iam_role.provisioner-iam-role.name
}
