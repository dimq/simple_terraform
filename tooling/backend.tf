terraform {
 backend "s3" {
   region         = "eu-west-1"
   bucket         = "simple-tf-state-test"
   key            = "terraform.tfstate"
   encrypt        = "true"
   dynamodb_table = "tf-statelock"
 }
}
