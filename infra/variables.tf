variable "subscription_id" { type = string }
variable "location" {
  type    = string
  default = "eastus"
}

variable "tags" {
  type = map(string)
  default = {
    owner   = "you"
    env     = "lab"
    project = "JDeMireFirstProject"
  }
}
