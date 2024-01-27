#By Obijah <ohbster@protonmail.com>

########
#Project Attributes
########
#The name to use for the resources
bucket_name = "ohbster-project-2"
#Set the region for the project
regions = [{
  region = "us-east-1"
  cidr   = "10.51.0.0/16"
  },
  {
    region = "us-west-2"
    cidr   = "10.52.0.0/16"
}]
region  = "us-east-1"
region2 = "us-west-2"
#common tags to apply to resources
common_tags = {
  Environment = "dev"
  Version     = ".1"
  Owner       = "ohbster@protonmail.com"
}

