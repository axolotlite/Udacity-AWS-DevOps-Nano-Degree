variable "key_pairs" {
  type = map(string)
  default = {
    "app"     = "basic_key"
    "bastion" = "basic_key"
  }
}
variable "availability_zones" {
  type = map(string)
  default = {
    "az1" = "us-east-1a"
    "az2" = "us-east-1b"
  }
}
variable "ami" {
  type = map(string)
  default = {
    "ubuntu"     = "ami-08d4ac5b634553e16"
    "amazon" = "ami-090fa75af13c156b4"
  }
}
variable "instance_type" {
  type = map(string)
  default = {
      "ubuntu"     = "t2.micro"
      "amazon" = "t2.micro"
  }
}
variable "cidrs" {
  type = map(string)
  default = {
    "vpc"   = "10.0.0.0/16"
    "pub0"  = "10.0.0.0/24"
    "pub1"  = "10.0.1.0/24"
    "priv0" = "10.0.2.0/24"
    "priv1" = "10.0.3.0/24"
  }
}