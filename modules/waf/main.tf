resource "aws_wafv2_web_acl" "this" {
  name  = "${terraform.workspace}-web-acl"
  scope = "REGIONAL"

  default_action {
    allow {}
  }

  # Rule 1: Managed Common Rule Set (XSS, SQLi, etc.)
  rule {
    name     = "AWSManagedRulesCommonRuleSet"
    priority = 1
    override_action {
      none {}
    }
    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "${terraform.workspace}-waf-common"
      sampled_requests_enabled   = true
    }
  }

  # Rule 2: Rate Limiting
  # Blocks IPs that send more than 1000 requests in a 5-minute window
  rule {
    name     = "HttpRateLimit"
    priority = 2
    action {
      block {}
    }
    statement {
      rate_based_statement {
        limit              = 1000
        aggregate_key_type = "IP"
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "${terraform.workspace}-waf-rate-limit"
      sampled_requests_enabled   = true
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "${terraform.workspace}-web-acl-main"
    sampled_requests_enabled   = true
  }

  tags = merge(
    { Name = "${terraform.workspace}-web-acl" },
    var.tags
  )
}