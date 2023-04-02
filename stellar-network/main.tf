module "kubernetes_namespace" {
  source = "terraform-kubernetes-modules/namespace/kubernetes"

  metadata = {
    name = var.namespace_name
  }

  labels = {
    app = "stellar"
  }
}

module "kubernetes_service_account" {
  source = "terraform-kubernetes-modules/service-account/kubernetes"

  metadata = {
    name      = "stellar-service-account"
    namespace = module.kubernetes_namespace.metadata.name
  }
}

module "kubernetes_role" {
  source = "terraform-kubernetes-modules/role/kubernetes"

  metadata = {
    name      = "stellar-role"
    namespace = module.kubernetes_namespace
  }

  rules = [
    {
      api_groups = [""]
      resources  = ["pods", "services"]
      verbs      = ["get", "list", "watch", "create", "update", "patch", "delete"]
    }
  ]
}

module "kubernetes_role_binding" {
  source = "terraform-kubernetes-modules/role-binding/kubernetes"

  metadata = {
    name      = "stellar-role-binding"
    namespace = module.kubernetes_namespace.metadata.name
  }

  role_ref = {
    kind     = "Role"
    name     = module.kubernetes_role.metadata.name
    apiGroup = "rbac.authorization.k8s.io"
  }

  subjects = [
    {
      kind      = "ServiceAccount"
      name      = module.kubernetes_service_account.metadata.name
      namespace = module.kubernetes_namespace.metadata.name
    }
  ]
}

module "stellar_core_deployment" {
  source = "./stellar-core"

  name_suffix              = var.core_service_name_prefix
  namespace_name           = module.kubernetes_namespace.metadata.name
  database_url_secret_name = var.database_url_secret_name
}

module "stellar_horizon_deployment" {
  source = "./stellar-horizon"

  name_suffix              = var.horizon_service_name_prefix
  namespace_name           = module.kubernetes_namespace.metadata.name
  database_url_secret_name = var.database_url_secret_name
}