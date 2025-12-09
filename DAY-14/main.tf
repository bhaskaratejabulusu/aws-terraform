// Create a private S3 bucket.
resource "aws_s3_bucket" "static_bucket" {
    bucket = var.s3_bucket_name


    tags = {
      Name = "static private bucket"
    }
       
}


// Block all public access to the S3 bucket.
resource "aws_s3_bucket_public_access_block" "block_public_access" {

    bucket = aws_s3_bucket.static_bucket.id  // implicit dependency on S3 bucket

    block_public_acls = true
    block_public_policy = true
    ignore_public_acls = true
    restrict_public_buckets = true
}


// Add bucket policy to allow access from another CloudFront 
resource "aws_s3_bucket_policy" "allow_access_from_another_account" {
  bucket = aws_s3_bucket.static_bucket.id // implicit dependency on S3 bucket

depends_on = [aws_s3_bucket_public_access_block.block_public_access]
  policy = local.s3_bucket_policy
}



// Add files to the S3 bucket
resource "aws_s3_object" "static_files" {
    bucket = aws_s3_bucket.static_bucket.id  // implicit dependency on S3 bucket
    for_each = fileset("${path.module}/www","**")
    key = each.value
    source = "${path.module}/www/${each.value}"

    etag = filemd5("${path.module}/www/${each.value}")

    content_type = lookup({
        html = "text/html",
        css  = "text/css",
        js   = "application/javascript",
        png  = "image/png",
        jpg  = "image/jpeg",
        jpeg = "image/jpeg",
        gif  = "image/gif",
        svg  = "image/svg+xml"
    }, split(".", each.value)[length(split(".", each.value)) - 1], "application/octet-stream")
}



// origin access control for CloudFront
resource "aws_cloudfront_origin_access_control" "cloudfront_oac" {
  name                              = "CloudFront-OAC"
  description                       = "OAC for accessing S3 bucket"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}


// create CloudFront distribution
resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name              = aws_s3_bucket.static_bucket.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.cloudfront_oac.id
    origin_id                = var.s3_origin_id
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "Some comment"
  default_root_object = "index.html"

#   aliases = ["mysite.${local.my_domain}", "yoursite.${local.my_domain}"]

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = var.s3_origin_id 

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  price_class = "PriceClass_200"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
  viewer_certificate {
    cloudfront_default_certificate = true
  }
}

