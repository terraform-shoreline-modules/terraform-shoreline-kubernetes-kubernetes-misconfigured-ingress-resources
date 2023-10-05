resource "shoreline_notebook" "kubernetes_misconfigured_ingress_resources" {
  name       = "kubernetes_misconfigured_ingress_resources"
  data       = file("${path.module}/data/kubernetes_misconfigured_ingress_resources.json")
  depends_on = [shoreline_action.invoke_ingress_check,shoreline_action.invoke_redeploy_ingress_resources]
}

resource "shoreline_file" "ingress_check" {
  name             = "ingress_check"
  input_file       = "${path.module}/data/ingress_check.sh"
  md5              = filemd5("${path.module}/data/ingress_check.sh")
  description      = "The Ingress resource was not properly configured with the appropriate routing rules and security policies."
  destination_path = "/agent/scripts/ingress_check.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "redeploy_ingress_resources" {
  name             = "redeploy_ingress_resources"
  input_file       = "${path.module}/data/redeploy_ingress_resources.sh"
  md5              = filemd5("${path.module}/data/redeploy_ingress_resources.sh")
  description      = "Re-deploy the ingress resources to ensure that they are correctly configured and functional."
  destination_path = "/agent/scripts/redeploy_ingress_resources.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_ingress_check" {
  name        = "invoke_ingress_check"
  description = "The Ingress resource was not properly configured with the appropriate routing rules and security policies."
  command     = "`chmod +x /agent/scripts/ingress_check.sh && /agent/scripts/ingress_check.sh`"
  params      = ["INGRESS_NAME","NAMESPACE","PATH_TO_KUBECONFIG_FILE"]
  file_deps   = ["ingress_check"]
  enabled     = true
  depends_on  = [shoreline_file.ingress_check]
}

resource "shoreline_action" "invoke_redeploy_ingress_resources" {
  name        = "invoke_redeploy_ingress_resources"
  description = "Re-deploy the ingress resources to ensure that they are correctly configured and functional."
  command     = "`chmod +x /agent/scripts/redeploy_ingress_resources.sh && /agent/scripts/redeploy_ingress_resources.sh`"
  params      = ["INGRESS_NAME","NAMESPACE","INGRESS_CONFIG_FILE"]
  file_deps   = ["redeploy_ingress_resources"]
  enabled     = true
  depends_on  = [shoreline_file.redeploy_ingress_resources]
}

