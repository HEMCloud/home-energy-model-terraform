resource "aws_s3_bucket" "my_bucket" {
  bucket = "unique-hem-tf-test-bucket-2"
  tags = {
    Name = "My bucket"
  }
}
