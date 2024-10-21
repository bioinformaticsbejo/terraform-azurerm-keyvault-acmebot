variable "function_app_name" {
  type        = string
  description = "The name of the Function App to create."
}

variable "allowed_ip_addresses" {
  type        = list(string)
  description = "A list of allowed ip addresses that can access the Acmebot UI."
  default     = []
}

variable "app_service_plan_name" {
  type        = string
  description = "The name of the App Service Plan to create."
}

variable "storage_account_name" {
  type        = string
  description = "The name of the Storage Account to create."
}

variable "storage_account_default_action" {
  type        = string
  description = "Default action for Storage Account's network rules."
  default     = "Deny"
}

variable "app_insights_name" {
  type        = string
  description = "The name of the Application Insights to create."
}

variable "workspace_name" {
  type        = string
  description = "The name of the Log Analytics Workspace to create."
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name to be added."
}

variable "auth_settings" {
  type = object({
    enabled                       = bool
    issuer                        = string
    token_store_enabled           = bool
    unauthenticated_client_action = string
    active_directory = object({
      client_id                  = string
      client_secret_setting_name = string
      tenant_id                  = string
      allowed_audiences          = list(string)
      allowed_applications       = list(string)
    })
  })
  description = "Authentication settings for the function app"
  default     = null
}

variable "app_settings" {
  description = "Additional settings to set for the function app"
  type        = map(string)
  default     = {}
}

variable "cors_allowed_origins" {
    type     = list(string)
    nullable = true
    default  = null
}

variable "allowed_external_redirect_urls" {
    type     = list(string)
    nullable = true
    default  = null
}

variable "location" {
  type        = string
  description = "Azure region to create resources."
}

variable "vault_uri" {
  type        = string
  description = "URL of the Key Vault to store the issued certificate."
}

variable "mail_address" {
  type        = string
  description = "Email address for ACME account."
}

variable "acme_endpoint" {
  type        = string
  description = "Certification authority ACME Endpoint."
  default     = "https://acme-v02.api.letsencrypt.org/"
}

variable "environment" {
  type        = string
  description = "The name of the Azure environment."
  default     = "AzureCloud"
}

variable "time_zone" {
  type        = string
  description = "The name of time zone as the basis for automatic update timing."
  default     = "UTC"
}

variable "webhook_url" {
  type        = string
  description = "The webhook where notifications will be sent."
  default     = null
}

variable "mitigate_chain_order" {
  type        = bool
  description = "Mitigate certificate ordering issues that occur with some services."
  default     = false
}

variable "external_account_binding" {
  type = object({
    key_id    = string
    hmac_key  = string
    algorithm = string
  })
  default = null
}

variable "sku_name" {
  type = string
  description = "Function app SKU name"
  default = "Y1"
  validation {
    condition     = contains(["B1", "B2", "B3", "D1", "F1", "I1", "I2", "I3", "I1v2", "I2v2", "I3v2", "P1v2", "P2v2", "P3v2", "P1v3", "P2v3", "P3v3", "S1", "S2", "S3", "SHARED", "EP1", "EP2", "EP3", "WS1", "WS2", "WS3", "Y1"], var.sku_name)
    error_message = "Invalid sku_name."
  }
}

variable "always_on" {
    type = bool
    default = false
    nullable = false
}

variable "app_scale_limit" {
  type = number
  description = "Function app scale limit"
  default = 2
}

variable "ip_restriction_default_action" {
  type = string
  description = "The Default action for traffic that does not match any ip_restriction rule."
  default = "Allow"
}

variable "vnet_route_all_enabled" {
  type = bool
  description = "Function route all traffic via vnet"
  default = false
}

variable "virtual_network_subnet_ids_integration" {
  type = list(string)
  description = "Single subnet to integrate function into. Not compatible with allowed_ip_addresses"
  default = []
  validation {
    condition     = length(var.virtual_network_subnet_ids_integration) == 0 || length(var.virtual_network_subnet_ids_integration) == 1
    error_message = "Only one permitted."
  }
}


variable "virtual_network_subnet_ids_pe" {
  type = list(string)
  description = "List of subnets for creating Private Endpoints"
  default = []
}

variable "virtual_network_subnet_ids_extra" {
  type = list(string)
  description = "List of extra subnets to allow access to the function"
  default = []
}


variable "private_dns_zone_rg" {
  type = string
  description = "Private DNS zone resource group"
  default = null
  nullable = true
}

variable "private_dns_zone_names_function" {
  type = object(
    {
      web = string
    }
  )
  description = "Private DNS zone name for function"
  default = null
  nullable = true
}

variable "private_dns_zone_names_storage" {
  type = object(
    {
      blob  = string
      queue = string
      table = string
    }
  )
  description = "Private DNS zone names for storage"
  default = null
  nullable = true
}





# DNS Provider Configuration
variable "azure_dns" {
  type = object({
    subscription_id = string
  })
  default = null
}

variable "cloudflare" {
  type = object({
    api_token = string
  })
  default = null
}

variable "custom_dns" {
  type = object({
    endpoint            = string
    api_key             = string
    api_key_header_name = string
    propagation_seconds = number
  })
  default = null
}

variable "dns_made_easy" {
  type = object({
    api_key    = string
    secret_key = string
  })
  default = null
}

variable "gandi" {
  type = object({
    api_key = string
  })
  default = null
}

variable "go_daddy" {
  type = object({
    api_key    = string
    api_secret = string
  })
  default = null
}

variable "google_dns" {
  type = object({
    key_file64 = string
  })
  default = null
}

variable "route_53" {
  type = object({
    access_key = string
    secret_key = string
    region     = string
  })
  default = null
}

variable "trans_ip" {
  type = object({
    customer_name    = string
    private_key_name = string
  })
  default = null
}

variable "tags" {
  type = map
  nullable = true
  default = {}
}

locals {
  external_account_binding = var.external_account_binding != null ? {
    "Acmebot:ExternalAccountBinding:KeyId"     = var.external_account_binding.key_id
    "Acmebot:ExternalAccountBinding:HmacKey"   = var.external_account_binding.hmac_key
    "Acmebot:ExternalAccountBinding:Algorithm" = var.external_account_binding.algorithm
  } : {}

  azure_dns = var.azure_dns != null ? {
    "Acmebot:AzureDns:SubscriptionId" = var.azure_dns.subscription_id
  } : {}

  cloudflare = var.cloudflare != null ? {
    "Acmebot:Cloudflare:ApiToken" = var.cloudflare.api_token
  } : {}

  custom_dns = var.custom_dns != null ? {
    "Acmebot:CustomDns:Endpoint"           = var.custom_dns.endpoint
    "Acmebot:CustomDns:ApiKey"             = var.custom_dns.api_key
    "Acmebot:CustomDns:ApiKeyHeaderName"   = var.custom_dns.api_key_header_name
    "Acmebot:CustomDns:PropagationSeconds" = var.custom_dns.propagation_seconds
  } : {}

  dns_made_easy = var.dns_made_easy != null ? {
    "Acmebot:DnsMadeEasy:ApiKey"    = var.dns_made_easy.api_key
    "Acmebot:DnsMadeEasy:SecretKey" = var.dns_made_easy.secret_key
  } : {}

  gandi = var.gandi != null ? {
    "Acmebot:Gandi:ApiKey" = var.gandi.api_key
  } : {}

  go_daddy = var.go_daddy != null ? {
    "Acmebot:GoDaddy:ApiKey"    = var.go_daddy.api_key
    "Acmebot:GoDaddy:ApiSecret" = var.go_daddy.api_secret
  } : {}

  google_dns = var.google_dns != null ? {
    "Acmebot:GoogleDns:KeyFile64" = var.google_dns.key_file64
  } : {}

  route_53 = var.route_53 != null ? {
    "Acmebot:Route53:AccessKey" = var.route_53.access_key
    "Acmebot:Route53:SecretKey" = var.route_53.secret_key
    "Acmebot:Route53:Region"    = var.route_53.region
  } : {}

  trans_ip = var.trans_ip != null ? {
    "Acmebot:TransIp:CustomerName"   = var.trans_ip.customer_name
    "Acmebot:TransIp:PrivateKeyName" = var.trans_ip.private_key_name
  } : {}

  webhook_url = var.webhook_url != null ? {
    "Acmebot:Webhook" = var.webhook_url
  } : {}

  common = {
    "Acmebot:Contacts"           = var.mail_address
    "Acmebot:Endpoint"           = var.acme_endpoint
    "Acmebot:VaultBaseUrl"       = var.vault_uri
    "Acmebot:Environment"        = var.environment
    "Acmebot:MitigateChainOrder" = var.mitigate_chain_order
  }

  acmebot_app_settings = merge(
    local.common,
    local.external_account_binding,
    local.azure_dns,
    local.cloudflare,
    local.custom_dns,
    local.dns_made_easy,
    local.gandi,
    local.go_daddy,
    local.google_dns,
    local.route_53,
    local.trans_ip,
    local.webhook_url,
  )
}

locals {
  virtual_network_subnet_ids_integration_dict = {for i, v in var.virtual_network_subnet_ids_integration: i => v}
  virtual_network_subnet_ids_pe_dict          = {for i, v in var.virtual_network_subnet_ids_pe         : i => v}
  virtual_network_subnet_ids_extra_dict       = {for i, v in var.virtual_network_subnet_ids_extra      : i => v}

  function_ip_restrictions = {
    for l, w in concat(
      [for v in var.allowed_ip_addresses                  : {"ip_address" = length(regexall(".*\\/.*", v)) > 0 ? v : format("%s/32", v), "virtual_network_subnet_id" = null}],
      [for v in var.virtual_network_subnet_ids_pe         : {"ip_address" =                                                        null, "virtual_network_subnet_id" =    v}],
      [for v in var.virtual_network_subnet_ids_integration: {"ip_address" =                                                        null, "virtual_network_subnet_id" =    v}],
      [for v in var.virtual_network_subnet_ids_extra      : {"ip_address" =                                                        null, "virtual_network_subnet_id" =    v}]
    ): l => w
  }

  storage_pe = merge(concat(
    [
      for subnet_pos, subnet_id in local.virtual_network_subnet_ids_pe_dict: {
        for subresource_name in ["blob", "queue", "table"]:
          "${subnet_pos}-${subresource_name}" => {
            "subnet_pos"            = subnet_pos,
            "subnet_id"             = subnet_id,
            "subresource_name"      = subresource_name,
            "private_dns_zone_name" = var.private_dns_zone_names_storage[subresource_name]
        }
      }
    ]
  )...)
}

