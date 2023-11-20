resource "aws_s3_bucket" "wordpress_logs" {
  bucket = "om9964064777"  # Replace with your desired bucket name
  tags = {
    Name = "My WordPress Logs Bucket"
  }
}

resource "aws_s3_bucket_ownership_controls" "wordpress_logs_ownership" {
  bucket = aws_s3_bucket.wordpress_logs.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "wordpress_bucket_acl" {
    depends_on = [aws_s3_bucket_ownership_controls.wordpress_logs_ownership]
  bucket = aws_s3_bucket.wordpress_logs.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "log_versioning" {
  bucket = aws_s3_bucket.wordpress_logs.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_logging" "logging" {
  bucket = aws_s3_bucket.wordpress_logs.id

  target_bucket = aws_s3_bucket.logs_bucket.id
  target_prefix = "log/"
}



resource "aws_s3_bucket" "logs_bucket" {
  bucket = "mylogsbucket9964064777"  # Replace with a unique bucket name for storing logs
  tags = {
    Name = "My Logs Bucket"
  }
}

resource "aws_s3_bucket_ownership_controls" "log_bucket_ownership" {
  bucket = aws_s3_bucket.logs_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}



resource "aws_s3_bucket_acl" "log_bucket_acl" {
    depends_on = [aws_s3_bucket_ownership_controls.log_bucket_ownership]
  bucket = aws_s3_bucket.logs_bucket.id
  acl    = "private"
}