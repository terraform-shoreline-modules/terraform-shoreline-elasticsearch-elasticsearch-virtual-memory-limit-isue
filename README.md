
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# Elasticsearch virtual memory limit issue
---

This incident type occurs when the Elasticsearch service is unable to function properly due to low virtual memory limit. Elasticsearch requires a minimum virtual memory limit to be set in the system, failing which it encounters issues such as "max virtual memory areas vm.max_map_count [65530] is too low, increase to at least". This error message indicates that the virtual memory limit set in the system is below the required minimum limit. This incident can cause system downtime and impact the performance of applications that rely on Elasticsearch.

### Parameters
```shell
export NEW_VALUE="PLACEHOLDER"

export MINIMUM_REQUIRED_VALUE="PLACEHOLDER"
```

## Debug

### Check the current virtual memory limit
```shell
sysctl vm.max_map_count
```

### Increase the virtual memory limit temporarily
```shell
sudo sysctl -w vm.max_map_count=${NEW_VALUE}
```

### Increase the virtual memory limit permanently
```shell
echo "vm.max_map_count=${NEW_VALUE}" | sudo tee -a /etc/sysctl.conf
```

### Check the current memory usage of Elasticsearch
```shell
sudo systemctl status elasticsearch
```

### Check the Elasticsearch logs for any related errors
```shell
sudo journalctl -u elasticsearch | grep -i error
```

### The system's virtual memory limit was not set to the minimum required value for Elasticsearch to function properly.
```shell
#!/bin/bash

# Check if vm.max_map_count is set to the minimum required value for Elasticsearch
if [[ $(sysctl -n vm.max_map_count) -lt ${MINIMUM_REQUIRED_VALUE} ]]; then
    echo "vm.max_map_count is set to a value lower than the required minimum for Elasticsearch."
    echo "Please update the virtual memory limit to at least ${MINIMUM_REQUIRED_VALUE}."
else
    echo "vm.max_map_count is set to a value equal to or greater than the required minimum for Elasticsearch."
    echo "The virtual memory limit is not the root cause of this particular incident."
fi
```

## Repair

### Increase the virtual memory limit to the minimum required value. This can be done by updating the "vm.max_map_count" kernel parameter value to a higher value. This can be achieved on Linux systems by running the command "sysctl -w vm.max_map_count=<new_value>" as the root user.
```shell
#!/bin/bash

# Set the new value for the vm.max_map_count parameter
new_value=${NEW_VALUE}

# Check if the script is being run as the root user
if [ "$EUID" -ne 0 ]

  then echo "Please run the script as root"

  exit
fi

# Update the vm.max_map_count parameter with the new value
sysctl -w vm.max_map_count=$new_value

# Check if the update was successful
if [ $? -eq 0 ]
  then echo "vm.max_map_count has been updated to $new_value"
else
  echo "Failed to update vm.max_map_count"
fi
```