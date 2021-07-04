resource "aws_s3_bucket" "om_panjagall" {
  bucket = "om-sample-bucket"
  acl    = "private"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}