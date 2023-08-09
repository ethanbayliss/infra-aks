#!/bin/bash

trap 'catch $? $LINENO' ERR
catch() {
  error "Line $2: $1"
}

LOGLEVEL='DEBUG'

# Logging functions
function log_output {
  printf "$(date +%T) $1\n"
}

function debug {
  if [[ "$LOGLEVEL" =~ ^(DEBUG)$ ]]; then
    log_output "DEBUG $1"
  fi
}

function info {
  if [[ "$LOGLEVEL" =~ ^(DEBUG|INFO)$ ]]; then
    log_output "INFO $1"
  fi
}

function error {
  if [[ "$LOGLEVEL" =~ ^(DEBUG|INFO|ERROR)$ ]]; then
    log_output "ERROR $1"
  fi
}

if [[ ! "$LOGLEVEL" =~ ^(DEBUG|INFO|ERROR)$ ]]; then
  error "Logging level needs to be DEBUG, INFO or ERROR."
  exit 1
fi

# Check all of the required utilities exist inside the container
command -v kubectl >/dev/null 2>&1 || { error "I require kubectl but it's not installed. Aborting." >&2; exit 2; }

# Get all of the files in a storage account


# Get credentials to the Kubernetes cluster


# Test authentication to the cluster


# Delete all of the manifests in the delete/ folder


# Apply all of the manifests in the top level folder


