terraform {
  backend "s3" {
    bucket = "terraform-state-tpxl7m"
    key    = "terraform/tradebot-webui-prod.tfstate"
    region = "us-east-1"
  }
}
