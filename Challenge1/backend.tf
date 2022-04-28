terraform {
    backend "s3" {
        bucket = "tf-state-bucket-challenge"
        key    = "development/terraform_state"
        region = "us-east-2"
    }
}