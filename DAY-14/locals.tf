// local variables
locals {
    s3_bucket_policy = templatefile(var.bucket_policy_file, {
        bucket_arn = aws_s3_bucket.static_bucket.arn,
        cloudfront_arn = aws_cloudfront_distribution.s3_distribution.arn
    })
}