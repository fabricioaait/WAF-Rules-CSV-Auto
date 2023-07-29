locals {
  csv_data = file(var.csv_file_path)
  csv_ips  = csvdecode(local.csv_data)
  description = "Variable needed to read from the CSV file the values like name, ip_address and etc"
  wafrule_details = [
    for wrd in local.csv_ips : {
      ipaddr      = wrd.ip_address
      type        = wrd.type
      name        = wrd.name
      priority    = wrd.priority
      description = wrd.description
    }
  ]

  rule_ipset_mapping = {
    for idx, rule in local.wafrule_details : rule.name => aws_waf_ipset.ipset[rule.name].id
  }

  rule_priorities = distinct([for rule in local.wafrule_details : rule.priority])
}

variable "web_acl_name" {
  type        = string
  description = "Name of the AWS WAF Web ACL."
}

variable "web_acl_metrics" {
  type        = string
  description = "Metric name for the AWS WAF Web ACL."
}

variable "csv_file_path" {
  type        = string
  description = "File path of the CSV containing the rules data."
}

variable "waf_rule_name" {
  type        = string
  description = "Name of the AWS WAF rule."
}

variable "waf_rule_metrics" {
  type        = string
  description = "Metric name for the AWS WAF rule."
}

variable "default_action" {
  type = string
  description = "Default action for rules ALLOW/BLOCK"

}

variable "rule_action" {
  type = string
  description = "Action for rules BLOCK/ALLOW"

}


