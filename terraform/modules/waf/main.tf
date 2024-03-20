resource "aws_wafv2_web_acl" "main" {
  name        = "${var.app_name}-waf"
  description = "${var.app_name} WAF."
  scope       = "REGIONAL"

  default_action {
    allow {}
  }
  rule {
    name     = "RateLimit"
    priority = 1

    action {
      block {}
    }

    statement {
      rate_based_statement {
        aggregate_key_type = "IP"
        limit              = 500
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "${var.app_name}-waf-RateLimit"
      sampled_requests_enabled   = true
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "${var.app_name}-waf"
    sampled_requests_enabled   = true
  }
  tags = {
     Project = "webapp"
  }
}
resource "aws_wafv2_web_acl_association" "main" {
  resource_arn = var.association_arn
  web_acl_arn  = aws_wafv2_web_acl.main.arn
}