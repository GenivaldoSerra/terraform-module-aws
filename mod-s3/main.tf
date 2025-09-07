resource "aws_s3_bucket" "this" {
  bucket = var.bucket_name

  tags = merge(
    locals.tags,
    {
      Name = var.bucket_name
    },
  )
}