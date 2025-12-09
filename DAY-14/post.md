Day 14 of #30DaysOfAwsTerraform ✅

I deployed a static website on AWS using S3 + CloudFront with Terraform. Highlights:
- Set up an S3 bucket for site hosting and blocked all public access
- Added a CloudFront Origin Access Control so traffic reaches S3 only through the CDN
- Generated a bucket policy from a template to allow CloudFront reads
- Synced the static site assets (HTML/CSS/JS/images) to the bucket
- Created a CloudFront distribution with HTTPS enforced and sensible caching defaults
- Exposed the CloudFront domain as the public endpoint

Why this matters:
- Private-by-default S3 plus CloudFront keeps content secure and cache-friendly
- Policy templating avoids manual JSON edits and scales to new sites
- Fast global delivery with minimal effort and cost

Next tweaks I’m considering:
- Adding a custom domain via Route 53 and ACM-managed TLS
- Tuning cache behaviors for static vs. dynamic assets
- Turning on WAF for extra edge security

#AWS #Terraform #CloudFront #S3 #DevOps #IaC #30DaysChallenge
