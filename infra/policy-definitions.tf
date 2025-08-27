# Apply policies only to the RGs created in this TF code (NOT the whole subscription)
# I'm using the Azure for Students subscription, so I only have one subscription to work with.
# That's why I'm only applying the policy at the RG level.

locals {
  policy_scopes = {
    platform = azurerm_resource_group.platform.id
    landing  = azurerm_resource_group.landing.id
  }

  # Policy parameters
  ######################################
  #Require every tag in var.tags
  required_tags = var.tags

  #Region enforcement (can adjust as needed)
  allowed_locations = ["eastus"]


}

#Custom policy definition to apply all tags to each resource group
resource "azurerm_policy_definition" "require_all_tags_rg" {
  name         = "require-all-tags-on-resources"
  display_name = "Require all specified tags and values on resources"
  description  = "Deny create/update when any required tag is missing or has a mismatched value."
  policy_type  = "Custom"
  mode         = "Indexed"

  # Build the rule dynamically from the var.tags map
  policy_rule = jsonencode({
    "if" : {
      # If ANY of these per-tag subconditions is true, the resource violates policy
      "anyOf" : [
        for tag_key, tag_val in local.required_tags : {
          "anyOf" : [
            { "field" : "tags['${tag_key}']", "exists" : "false" },
            { "field" : "tags['${tag_key}']", "notEquals" : tag_val }
          ]
        }
      ]
    },
    "then" : { "effect" : "deny" }
  })
}


# Built-in policy definitions (resolved by display name to avoid hardcoding GUIDs)
#Calls the built in policy that controls location restrictions
data "azurerm_policy_definition" "allowed_locations" {
  display_name = "Allowed locations"
}

#Calls the built in policy that controls resource types (in this case, the Public IP resource type)
data "azurerm_policy_definition" "not_allowed_resource_types" {
  display_name = "Not allowed resource types"
}


# 1) Require all tags (Deny if any tag is missing)
resource "azurerm_resource_group_policy_assignment" "require_all_tags" {
  for_each             = local.policy_scopes
  name                 = "require-all-tags-${each.key}"
  resource_group_id    = each.value
  policy_definition_id = azurerm_policy_definition.require_all_tags_rg.id
}


# 2) Allowed locations (DENY outside list), per RG
resource "azurerm_resource_group_policy_assignment" "allowed_locations" {
  for_each             = local.policy_scopes
  name                 = "allowed-locations-${each.key}"
  resource_group_id    = each.value
  policy_definition_id = data.azurerm_policy_definition.allowed_locations.id

  parameters = jsonencode({
    listOfAllowedLocations = { value = local.allowed_locations }
  })
}

# 3) Deny public IP resource type, per RG
resource "azurerm_resource_group_policy_assignment" "deny_public_ip" {
  for_each             = local.policy_scopes
  name                 = "deny-public-ip-${each.key}"
  resource_group_id    = each.value
  policy_definition_id = data.azurerm_policy_definition.not_allowed_resource_types.id

  parameters = jsonencode({
    listOfResourceTypesNotAllowed = { value = ["Microsoft.Network/publicIPAddresses"] }
  })
}
