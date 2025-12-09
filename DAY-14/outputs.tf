output "s3_arn" {
    value = aws_s3_bucket.static_bucket.arn
    description = "The ARN of the S3 bucket"
}

output "cloudfront_dns" {
    description = "The DNS of the CloudFront"
    value = aws_cloudfront_distribution.s3_distribution.domain_name
  
}

output "cloudfront_arn" {
    value = aws_cloudfront_origin_access_control.cloudfront_oac.arn
  
}

output "cloudfront_arn2" {
    value = aws_cloudfront_distribution.s3_distribution.arn
  
}