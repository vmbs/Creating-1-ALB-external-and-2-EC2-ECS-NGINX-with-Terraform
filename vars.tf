variable "aws_region" {
  description = "The AWS region to create things in."
  default     = "eu-central-1"
}
 
variable "instance_type" {
  default     = "t2.micro"
  description = "AWS instance type"
}
