terraform {
  backend "s3" {
    bucket = "vv-demo-bucket"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}
  
