# WAFv1-Rules-CSV-Auto

Repository for a code will automate the creation of AWS WAFv1 Rules using CSV as input.

***This code does not consider authentication, user must decide best suited authentication method.***

The code will iterate trough a CSV file to get info needed for the creation of IPset and Waf rules like the IPs, the name, the priority of the rule, remember the priorities must be unique values, can't be two or more rules with the same priority number otherwise will fail. In the variable file vars.tfvars we can setup the name and other values we want. For default the variable default_action, which controls the default action or the rules is setup to ALLOW, so it will allow anything to pass and the rules added will block whatever we define, the behavior, can be changed inverting the values, BLOCK for default_action and ALLOW for rule_action. After created the web acl can be associated to the resources supporting wafv1 global rules like Cloudfront distributions.

magic command: terraform apply -var-file=vars.tfvars -auto-approve
