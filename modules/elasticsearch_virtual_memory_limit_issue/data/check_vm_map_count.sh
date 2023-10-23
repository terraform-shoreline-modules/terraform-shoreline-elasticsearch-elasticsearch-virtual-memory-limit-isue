#!/bin/bash

# Check if vm.max_map_count is set to the minimum required value for Elasticsearch
if [[ $(sysctl -n vm.max_map_count) -lt ${MINIMUM_REQUIRED_VALUE} ]]; then
    echo "vm.max_map_count is set to a value lower than the required minimum for Elasticsearch."
    echo "Please update the virtual memory limit to at least ${MINIMUM_REQUIRED_VALUE}."
else
    echo "vm.max_map_count is set to a value equal to or greater than the required minimum for Elasticsearch."
    echo "The virtual memory limit is not the root cause of this particular incident."
fi