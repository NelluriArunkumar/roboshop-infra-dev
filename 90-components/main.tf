module "user" {
    for_each = var.components
    #source = "../../terraform-aws-roboshop"
    source = "git::https://github.com/NelluriArunkumar/terraform_aws_roboshop.git?ref=main"
    component = each.key
    rule_priority = each.value.rule_priority
  
}