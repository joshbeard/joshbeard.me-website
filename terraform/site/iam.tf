# IAM policy and user for updating my resume in this bucket.
data "aws_iam_policy_document" "resume_update" {
  statement {
    sid = "DeployWebsite"
    actions = [
      "s3:DeleteObject",
      "s3:ListBucket",
      "s3:PutObject",
      "s3:PutObjectAcl",
      "s3:PutObjectVersionAcl"
    ]
    resources = [
      "${module.joshbeard_me_aws.s3_bucket_arn}/resume/*"
    ]
  }

  statement {
    sid = "DeployWebsiteCloudfront"
    actions = [
      "cloudfront:CreateInvalidation"
    ]
    resources = [module.joshbeard_me_aws.cloudfront_arn]
  }
}

resource "aws_iam_policy" "resume_update" {
  name   = "s3-deploy-resume"
  path   = "/"
  policy = data.aws_iam_policy_document.resume_update.json
  tags   = local.tags
}

resource "aws_iam_user" "resume_update" {
  name = "s3-deployer-resume"
  path = "/"
  tags = local.tags
}

resource "aws_iam_user_policy_attachment" "resume_update" {
  user       = aws_iam_user.resume_update.name
  policy_arn = aws_iam_policy.resume_update.arn
}