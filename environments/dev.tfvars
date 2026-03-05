region             = "ap-south-1"
vpc_cidr           = "10.1.0.0/16"
availability_zones = ["ap-south-1a", "ap-south-1b"]
instance_type      = "t3.micro"
desired_capacity   = 4
max_size           = 6
min_size           = 2
email_endpoint     = "mdimam25m@gmail.com"
enable_waf         = true
app_port           = 80
additional_tags = {
  env       = "dev" 
  ManagedBy = "Terraform"
}