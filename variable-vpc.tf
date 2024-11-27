variable "region" {
  default = "us-east-1"
}

variable "subnets" {
  type = map(object({
    name              = string,
    cidr              = string,
    availability_zone = string
  }))
  default = {
    "subnet-1" = {
      name              = "dev-subnet-1",
      cidr              = "10.0.1.0/24",
      availability_zone = "us-east-1a"
    },
    "subnet-2" = {
      name              = "dev-subnet-2",
      cidr              = "10.0.2.0/24",
      availability_zone = "us-east-1b"
    },
    "subnet-3" = {
      name              = "dev-subnet-3",
      cidr              = "10.0.3.0/24",
      availability_zone = "us-east-1c"
    }
  }
}