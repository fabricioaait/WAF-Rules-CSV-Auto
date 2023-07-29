# The scope of this code is generate rules dynamically inside an web_acl with 
# block action for IPs in a default allow behaviour from a csv file previous fulfilled with the basic info needed: 
# name, priority, IP, type and number for control. Priority and Rule_number must be unique on csv fileds data. 
# ACL can be adapted to change to default allow and block rules or vice versa changing variables 

resource "aws_waf_ipset" "ipset" {
  for_each = { for idx, rule in local.wafrule_details : rule.name => rule }
  name     = "ipset-${each.value.name}"

  ip_set_descriptors {
    type  = each.value.type
    value = each.value.ipaddr
  }
}

resource "aws_waf_rule" "waf_rule" {
  for_each    = { for rule in local.wafrule_details : rule.name => rule }
  name        = "rule-${each.value.name}"
  metric_name = var.waf_rule_metrics

  predicates {
    data_id = aws_waf_ipset.ipset[each.value.name].id
    negated = false
    type    = "IPMatch"
  }
}

resource "aws_waf_web_acl" "waf_acl" {
  name        = "web-acl-${var.web_acl_name}"
  metric_name = var.web_acl_metrics

  default_action {
    type = var.default_action
  }

  dynamic "rules" {
    for_each = { for idx, rule in local.wafrule_details : idx => rule }
    content {
      action {
        type = var.rule_action
      }
      priority = rules.value.priority
      rule_id  = aws_waf_rule.waf_rule[rules.value.name].id
      type     = "REGULAR"
    }
  }
}
