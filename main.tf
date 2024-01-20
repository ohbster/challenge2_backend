terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}
provider "aws" {
  region = "us-east-1"
}
terraform {
  backend "s3" {
    bucket = "ohbster-ado-terraform-class5"
    key    = "dev/terraform.tfstate"
    region = "us-east-1"
  }
}


#This is used by mff_id tag. This is will identify all resources that belong to the terraform deployment
resource "random_uuid" "uuid" {

}

#This will add the mff_id uuid to the common tags that get passed to resources. This will identify resources that belong to this deployment
locals {
  common_tags = merge(var.common_tags, { mff_id = random_uuid.uuid.result })
}

# module "s3" {
#   source = "../../Terraform/myfinalform/aws/modules/s3"
#   name = "ohbster-project2-s3"
#   tags = var.common_tags

# }
resource "aws_s3_bucket" "bucket" {
  force_destroy = true
  bucket = "ohbster-project-2"
}

resource "aws_s3_bucket_public_access_block" "s3_public_block" {
  bucket = aws_s3_bucket.bucket.id

  block_public_acls       = false
  block_public_policy     = false
  # ignore_public_acls      = false
  # restrict_public_buckets = false
}


resource "aws_s3_bucket_website_configuration" "website_configuration" {
  bucket = aws_s3_bucket.bucket.id
  index_document {
    suffix = "index.html"
  }
}

resource "aws_s3_bucket_policy" "policy" {
  
  bucket = aws_s3_bucket.bucket.id
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PublicReadGetObject",
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": "${aws_s3_bucket.bucket.arn}/*"
        }
    ]
})
}

# module "vpc-network" {
#   providers = {
#     aws = aws.region-1
#   }
#   name                 = var.name
#   source               = "./modules/network"
#   region               = var.region
#   cidr                 = var.cidr
#   public_subnet_count  = var.public_subnet_count
#   private_subnet_count = var.private_subnet_count
#   tags                 = local.common_tags

# }


# module "ec2_instance_sg" {
#   source    = "./modules/security_group"
#   name      = var.name
#   port_list = var.port_list
#   vpc_id    = module.vpc-network.vpc_id
#   tags      = local.common_tags
# }
# module "instance" {
#   #The count will `instance_count` # of instances. Set this in the terraform.tfvar file
#   count  = var.instance_count
#   source = "./modules/instance"
#   name   = "${var.name}-instance-${count.index + 1}" #This will add the number of the instance to the name
#   #This will evenly distribute instances in the available public subnets
#   subnet_id          = module.vpc-network.public_subnet_ids[count.index % module.vpc-network.public_subnet_count]
#   vpc_id             = module.vpc-network.vpc_id
#   user_data          = var.user_data
#   instance_type      = var.instance_type
#   key_name           = var.key_name
#   port_list          = var.port_list
#   tags               = local.common_tags
#   security_group_ids = [module.ec2_instance_sg.security_group_id]
# }

# module "iam_user_group" {
#   source          = "./modules/iam_user_groups"
#   for_each        = var.group_map
#   user_list       = each.value
#   permission_list = var.action_map[each.key]
#   path            = var.path
#   name            = "${each.key}-grp"
#   tags            = local.common_tags
# }

