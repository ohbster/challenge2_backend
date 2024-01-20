########
#Project variables
########
variable "name" {
  type        = string
  description = "Main project name"

  validation {
    condition     = can(regex("^[a-zA-Z][a-zA-Z0-9-]{3,20}", var.name))
    error_message = "Invalid name: Start with letter, only letters, numbers and '-'"
  }
}

variable "regions" {
  type = list(object({
    region = string
    cidr   = string
  }))
  description = "Main regions"

}

variable "region" {
  type        = string
  description = "Main vpc region"
}

variable "region2" {
  type        = string
  description = "Main vpc region"
}

variable "common_tags" {
  type        = map(string)
  description = "Common Tags"
  default = {
    Environment = "dev"
    Version     = ".1"
    Owner       = "ohbster@protonmail.com"
  }
}

########
#Network variables
########
variable "cidr" {
  type        = string
  description = "Main vpc cidr"
  default     = "10.10.0.0/16"
}

variable "public_subnet_count" {
  type        = string
  description = "Main Public subnet count"
  default     = 1

  validation {
    condition     = var.public_subnet_count > 0
    error_message = "Enter a value greater than 0"
  }
}

variable "private_subnet_count" {
  type        = string
  description = "Main Private subnet count"
  default     = 1

  validation {
    condition     = var.private_subnet_count > 0
    error_message = "Enter a value greater than 0"
  }
}

########
#Instance variables
########
variable "instance_count" {
  type        = number
  description = "Main Instance count"
  default     = 1

  validation {
    condition     = var.instance_count < 10
    error_message = "Play it safe dey, soulja. Set instances to 10 or less."

  }
}
#user data file
variable "user_data" {
  type        = string
  description = "Main instance user data"
  default     = "sample_userdata_debian.sh"
}

variable "instance_type" {
  type        = string
  description = "Main instance type"
  default     = "t3.micro"
}

variable "key_name" {
  type        = string
  description = "Main instance key name"
}
#Open these ports to the instance security groups
variable "port_list" {
  type        = list(number)
  description = "Main instance port list"
  default     = [80, 22]
}

#####
#IAM STUFF BELOW
#####

variable "iam_map" {
  type        = map(string)
  description = "AWS IAM Map"
}

variable "group_map" {
  type = map(list(string))
}
variable "action_map" {
  type = map(list(string))
}
variable "path" {
  type    = string
  default = null
}

