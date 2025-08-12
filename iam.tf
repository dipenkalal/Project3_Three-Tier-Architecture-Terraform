resource "aws_iam_role" "ec2_role" {
  name = "ec2-s3-ssm-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}


resource "aws_iam_instance_profile" "ec2_s3_profile" {
  name = "ec2-s3-ssm-instance-profile"
  role = aws_iam_role.ec2_role.name
}


resource "aws_iam_policy" "ec2_s3_ssm_policy" {
  name        = "ec2-s3-ssm-policy"
  description = "Allow EC2 to access S3 and SSM"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        "Effect" : "Allow",
        "Action" : ["s3:ListBucket"],
        "Resource" : "arn:aws:s3:::dipen-app-backend-code"
      },
      {
        "Effect" : "Allow",
        "Action" : ["s3:GetObject"],
        "Resource" : "arn:aws:s3:::dipen-app-backend-code/*"
      },
      {
        "Effect" : "Allow",
        "Action" : ["ssm:GetParameter", "ssm:GetParameters", "ssm:GetParametersByPath"],
        "Resource" : "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ec2_s3_ssm_attach" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.ec2_s3_ssm_policy.arn
}

