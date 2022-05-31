# Copyright (c) 2022 Oracle and/or its affiliates. All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at http://oss.oracle.com/licenses/upl.
# 

variable "sysdig_access_key" {
  default     = ""
  description = "Sysdig Agent Access Key"
}

variable "sysdig_settings_collector" {
  default     = ""
  description = "Sysdig Agent Collector URL. (i.e. ingest-us2.app.sysdig.com)"
}

variable "sysdig_settings_collector_port" {
  default     = 6443
  description = "Sysdig Agent Collector Port"
}

variable "sysdig_secure_api_endpoint" {
  default     = ""
  description = "Sysdig secure API endpoint, without protocol (i.e. secure.sysdig.com)"
}

variable "sysdig_snyk_integration" {
  default     = false
  description = "Enrich security insights and automated remediation with Snyk and seamlessly integrated to more easily find, prioritize, and fix vulnerabilities in containers and open source dependencies."
}