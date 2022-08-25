data "aws_iam_policy_document" "assume_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "permissions" {
  statement {
    actions = [
      "cloudwatch:PutMetricData",
      "ec2:*",
      "ssm:*",
      "ec2messages:*",
      "s3:*",
      "sns:*"
    ]
    resources = ["*"]
  }
}

# Using custom vpc_and_subnet module
module "vpc_and_subnet" {
  source               = "./modules/vpc_and_subnet"
  environment          = var.environment
  vpc_cidr             = var.vpc_cidr
  private_subnets_cidr = var.private_subnets_cidr
  public_subnets_cidr  = var.public_subnets_cidr
}

# Create s3 bucket to store my Dockerfile
resource "aws_s3_bucket" "qbe-bucket" {
  bucket = "qbe-bucket"
}

# Copying local file to s3
# for docker deployment alternatives check: https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/single-container-docker-configuration.html
resource "aws_s3_object" "my_app_deployment" {
  bucket = aws_s3_bucket.qbe-bucket.id
  key    = "Dockerfile"
  source = "Dockerfile"
}

# Create instance profile
resource "aws_iam_instance_profile" "ec2_eb_profile" {
  name = "ec2-profile"
  role = aws_iam_role.ec2_role.name
}

resource "aws_iam_role" "ec2_role" {
  name               = "ec2-role"
  assume_role_policy = data.aws_iam_policy_document.assume_policy.json
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AWSElasticBeanstalkWebTier",
    "arn:aws:iam::aws:policy/AWSElasticBeanstalkWorkerTier",
  ]

  inline_policy {
    name   = "eb-application-permissions"
    policy = data.aws_iam_policy_document.permissions.json
  }
}

# Using custom beanstalk_env module
module "beanstalk_env" {
  source           = "./modules/beanstalk_env"
  app_tags         = var.environment
  application_name = var.environment
  bean_env_name    = var.bean_env_name
  vpc_id           = module.vpc_and_subnet.vpc_id
  ec2_subnets      = join(",", flatten(module.vpc_and_subnet.private_subnets_id))
  # work on later
  elb_subnets       = "${flatten(module.vpc_and_subnet.private_subnets_id)[0]},${flatten(module.vpc_and_subnet.private_subnets_id)[1]}"
  security_groups   = module.vpc_and_subnet.default_sg_id
  instance_type     = var.ec2_type
  ec2_profile       = aws_iam_instance_profile.ec2_eb_profile.arn
  app_http_response = var.APP_HTTP_RESPONSE
  app_port          = var.APP_PORT
}

# TODO: Api Gateway and WAF 
