# Copyright (c) 2022 Oracle and/or its affiliates. All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at http://oss.oracle.com/licenses/upl.
# 

# Namespace
resource "kubernetes_namespace" "sysdig_agent_namespace" {
  metadata {
    name = "sysdig-agent"
  }

  depends_on = [data.oci_containerengine_cluster_kube_config.oke]

  count = local.install_sysdig ? 1 : 0
}

# Helm Charts
## https://github.com/sysdiglabs/charts/tree/master/charts/agent
resource "helm_release" "sysdig_agent" {
  name       = "sysdig-agent"
  repository = local.sysdig_helm_repository.sysdig_charts
  chart      = "sysdig"
  namespace  = kubernetes_namespace.sysdig_agent_namespace.0.id
  version    = "1.14.32" #TEMP until the quickstart is fully reviewed for the new helm charts
  wait       = false

  set {
    name  = "clusterName"
    value = yamldecode(data.oci_containerengine_cluster_kube_config.oke.content)["users"][0]["user"]["exec"]["args"][4]
  }
  set {
    name  = "sysdig.accessKey"
    value = var.sysdig_access_key
  }
  set {
    name  = "sysdig.settings.collector"
    value = var.sysdig_settings_collector
  }
  set {
    name  = "sysdig.settings.collector_port"
    value = var.sysdig_settings_collector_port
  }
  set {
    name  = "nodeAnalyzer.apiEndpoint"
    value = var.sysdig_secure_api_endpoint
  }
  set {
    name  = "ebpf.enabled"
    value = true
  }
  set {
    name  = "nodeAnalyzer.runtimeScanner.deploy"
    value = true
  }
  set {
    name  = "nodeAnalyzer.runtimeScanner.eveConnector.deploy"
    value = true
  }
  set {
    name  = "resources.limits.cpu"
    value = "null"
  }
  set {
    name  = "sysdig.settings.cri.delay_ms"
    value = 500
  }
  set {
    name  = "sysdig.settings.falcobaseline.debug"
    value = false
  }
  set {
    name  = "sysdig.settings.falcobaseline.debug_metadata"  # to print baseliner workload metadata as info
    value = false
  }
  set {
    name  = "sysdig.settings.falcobaseline.report_interval" # necessary for baseliner to start
    value = 30000000000
  }
  set {
    name  = "sysdig.settings.falcobaseline.max_drops_buffer_rate_percentage" # necessary for baseliner to start
    value = 0.99
  }
  set {
    name  = "sysdig.settings.falcobaseline.max_sampling_ratio" # necessary for baseliner to start
    value = 128
  }
  set {
    name  = "sysdig.settings.falcobaseline.randomize_start" # necessary for baseliner to start
    value = false
  }


  count = local.install_sysdig ? 1 : 0
}

locals {
  # Helm repos
  sysdig_helm_repository = {
    sysdig_charts = "https://charts.sysdig.com"
  }

  # Sysdig Agent
  install_sysdig = true
}
