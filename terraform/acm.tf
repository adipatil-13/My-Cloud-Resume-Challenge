# Creating Certificate using Terraform

# Retrieve the Cloudflare zone ID
data "cloudflare_zones" "zone" {
  filter {
    name = var.domain_name
  }
}

# ACM Certificate
resource "aws_acm_certificate" "cert" {
  domain_name       = var.domain_name
  validation_method = "DNS"

  subject_alternative_names = [
    var.sub_domain_name
  ]

  tags = {
    Name = "custom-cert"
  }

  lifecycle {
    create_before_destroy = true
  }
}

locals {
  domain_validation_options = [
    for val in aws_acm_certificate.cert.domain_validation_options : {
      name  = val.resource_record_name
      value = val.resource_record_value
      type  = val.resource_record_type
    }
  ]
}

resource "cloudflare_record" "cert_validation" {

    zone_id = data.cloudflare_zones.zone.zones[0].id
    name    = local.domain_validation_options[0].name
    value   = local.domain_validation_options[0].value
    type    = local.domain_validation_options[0].type
    ttl     = 300

  depends_on = [aws_acm_certificate.cert]
}