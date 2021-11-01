###################################################

# Fetching all availability zones in us-east-1

###################################################

data "aws_availability_zones" "azs" {}

###################################################

# Fetching predefines IAM role

###################################################

data "aws_iam_role" "iam_role" {

  name = "EC2SSMRole"

}

