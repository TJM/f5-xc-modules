resource "volterra_virtual_k8s" "vk8s" {
  name        = var.f5xc_vk8s_name
  namespace   = var.f5xc_virtual_k8s_namespace
  description = var.f5xc_vk8s_description
  isolated    = var.f5xc_vk8s_isolated
  labels      = local.f5xc_labels

  dynamic "vsite_refs" {
    for_each = var.f5xc_virtual_site_refs
    content {
      name      = vsite_refs.value
      namespace = var.f5xc_vsite_refs_namespace
      tenant    = local.f5xc_tenant
    }
  }
}

module "vk8s_wait_for_online" {
  depends_on     = [volterra_virtual_k8s.vk8s]
  source         = "../status/vk8s"
  is_sensitive   = var.is_sensitive
  f5xc_api_token = local.f5xc_api_token
  f5xc_api_url   = var.f5xc_api_url
  f5xc_namespace = var.f5xc_virtual_k8s_namespace
  f5xc_tenant    = local.f5xc_tenant
  f5xc_vk8s_name = volterra_virtual_k8s.vk8s.name
}

module "api_credential_kubeconfig" {
  depends_on                 = [module.vk8s_wait_for_online]
  count                      = var.f5xc_create_k8s_creds == true && var.f5xc_k8s_credentials_name != "" ? 1 : 0
  source                     = "../api-credential"
  is_sensitive               = var.is_sensitive
  f5xc_tenant                = local.f5xc_tenant
  f5xc_api_url               = var.f5xc_api_url
  f5xc_api_token             = local.f5xc_api_token
  f5xc_namespace             = var.f5xc_api_credential_namespace
  f5xc_virtual_k8s_name      = volterra_virtual_k8s.vk8s.name
  f5xc_virtual_k8s_namespace = volterra_virtual_k8s.vk8s.namespace
  f5xc_api_credential_type   = "KUBE_CONFIG"
  f5xc_api_credentials_name  = var.f5xc_k8s_credentials_name
}
