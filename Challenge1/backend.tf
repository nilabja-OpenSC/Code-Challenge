terraform {
    backend "s3" {
        bucket = "tf-state-bucket"
        key    = "development/terraform_state"
        region = "us-east-2"
    }
}