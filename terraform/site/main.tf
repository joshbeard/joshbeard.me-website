# Deployment of AWS resources for joshbeard.me
locals {
  tags = { "git_repo" = "https://github.com/joshbeard/joshbeard.me-tf-aws" }
}

# module "dev_joshbeard_me_aws" {
#   source          = "github.com/joshbeard/tf-aws-site.git"
#   domain          = "dev.joshbeard.me"
#   log_bucket_name = "dev.joshbeard-logs"
#   tags            = merge(local.tags, { "environment" = "dev" })
# }

module "joshbeard_me_aws" {
  source          = "github.com/joshbeard/tf-aws-site.git"
  domain          = "joshbeard.me"
  log_bucket_name = "joshbeard-logs"
  tags            = local.tags
}

module "joshbeard_me_migadu" {
  source = "github.com/joshbeard/tf-migadu-route53.git"

  domain        = "joshbeard.me"
  zone_id       = module.joshbeard_me_aws.route53_zone_id
  migadu_verify = "d1wmwhle"
  txt_records = [
    "google-site-verification=RViz888k76klP5cJLLhWObOAMoYIF8vXMtXh52iMdNY",
    "keybase-site-verification=DCBFW1VwtOcrdnGbDKrcsthPHZtSCth1mWx0oUE-SS4"
  ]
}

resource "aws_route53_record" "github-verify-jbeard-dev" {
  zone_id = module.joshbeard_me_aws.route53_zone_id
  name    = "_github-challenge-jbeard-dev"
  type    = "TXT"
  ttl     = 300
  records = ["cca53abbe7"]
}

