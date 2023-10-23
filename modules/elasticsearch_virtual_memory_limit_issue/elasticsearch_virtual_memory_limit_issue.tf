resource "shoreline_notebook" "elasticsearch_virtual_memory_limit_issue" {
  name       = "elasticsearch_virtual_memory_limit_issue"
  data       = file("${path.module}/data/elasticsearch_virtual_memory_limit_issue.json")
  depends_on = [shoreline_action.invoke_check_vm_map_count,shoreline_action.invoke_set_vm_max_map_count]
}

resource "shoreline_file" "check_vm_map_count" {
  name             = "check_vm_map_count"
  input_file       = "${path.module}/data/check_vm_map_count.sh"
  md5              = filemd5("${path.module}/data/check_vm_map_count.sh")
  description      = "The system's virtual memory limit was not set to the minimum required value for Elasticsearch to function properly."
  destination_path = "/tmp/check_vm_map_count.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "set_vm_max_map_count" {
  name             = "set_vm_max_map_count"
  input_file       = "${path.module}/data/set_vm_max_map_count.sh"
  md5              = filemd5("${path.module}/data/set_vm_max_map_count.sh")
  description      = "Increase the virtual memory limit to the minimum required value. This can be done by updating the "vm.max_map_count" kernel parameter value to a higher value. This can be achieved on Linux systems by running the command "sysctl -w vm.max_map_count=<new_value>" as the root user."
  destination_path = "/tmp/set_vm_max_map_count.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_check_vm_map_count" {
  name        = "invoke_check_vm_map_count"
  description = "The system's virtual memory limit was not set to the minimum required value for Elasticsearch to function properly."
  command     = "`chmod +x /tmp/check_vm_map_count.sh && /tmp/check_vm_map_count.sh`"
  params      = ["MINIMUM_REQUIRED_VALUE"]
  file_deps   = ["check_vm_map_count"]
  enabled     = true
  depends_on  = [shoreline_file.check_vm_map_count]
}

resource "shoreline_action" "invoke_set_vm_max_map_count" {
  name        = "invoke_set_vm_max_map_count"
  description = "Increase the virtual memory limit to the minimum required value. This can be done by updating the "vm.max_map_count" kernel parameter value to a higher value. This can be achieved on Linux systems by running the command "sysctl -w vm.max_map_count=<new_value>" as the root user."
  command     = "`chmod +x /tmp/set_vm_max_map_count.sh && /tmp/set_vm_max_map_count.sh`"
  params      = ["NEW_VALUE"]
  file_deps   = ["set_vm_max_map_count"]
  enabled     = true
  depends_on  = [shoreline_file.set_vm_max_map_count]
}

