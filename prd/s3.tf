resource "aws_s3_bucket" "my_bucket" {
  bucket = "unique-hem-tf-test-bucket-prd"
  tags = {
    Name = "My bucket"
  }
}
