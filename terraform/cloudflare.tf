

resource "cloudflare_record" "root_domain" {
  zone_id = "9da85b46472659a4392aa2b733b16808"
  name    = var.domain_name
  value   = aws_cloudfront_distribution.frontend_distribution.domain_name
  type    = "CNAME"
  proxied = true

  depends_on = [
    aws_cloudfront_distribution.frontend_distribution
  ]
}

resource "cloudflare_record" "wildcard_subdomain" {
  zone_id = "9da85b46472659a4392aa2b733b16808"
  name    = var.sub_domain_name
  value   = aws_cloudfront_distribution.frontend_distribution.domain_name
  type    = "CNAME"
  proxied = true

  depends_on = [
    aws_cloudfront_distribution.frontend_distribution
  ]
}

# Purge Cloudflare cache for both root domain and subdomain using local-exec provisioner
resource "null_resource" "purge_cache" {
  provisioner "local-exec" {
    command = <<EOT
      curl -X POST "https://api.cloudflare.com/client/v4/zones/${data.cloudflare_zones.zone.zones[0].id}/purge_cache" \
      -H "Authorization: Bearer ${var.cloudflare_api_token}" \
      -H "Content-Type: application/json" \
      --data '{"purge_everything":true}'
    EOT
  }

   triggers = {
    always_run = "${timestamp()}"
  }

  depends_on = [
    cloudflare_record.root_domain,
    cloudflare_record.wildcard_subdomain
  ]
}