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