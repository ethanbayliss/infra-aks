#!/bin/bash

RED="\e[31m"
GREEN="\e[32m"
ORANGE="\e[33m"
ITALICRED="\e[3;${RED}"
ENDCOLOR="\e[0m"

trap 'catch $? $LINENO' ERR
catch() {
  error "Line $2: $1"
  exit
}

LOGLEVEL='DEBUG'

# Logging functions
function log_output {
  printf "$(date +%T) $1\n"
}

function debug {
  if [[ "$LOGLEVEL" =~ ^(DEBUG)$ ]]; then
    log_output "${ITALICRED}DEBUG $1${ENDCOLOR}"
  fi
}

function info {
  if [[ "$LOGLEVEL" =~ ^(DEBUG|INFO)$ ]]; then
    log_output "${GREEN}INFO $1${ENDCOLOR}"
  fi
}

function warn {
  if [[ "$LOGLEVEL" =~ ^(DEBUG|INFO|WARN)$ ]]; then
    log_output "${ORANGE}WARN $1${ENDCOLOR}"
  fi
}

function error {
  if [[ "$LOGLEVEL" =~ ^(DEBUG|INFO|WARN|ERROR)$ ]]; then
    log_output "${RED}ERROR $1${ENDCOLOR}"
  fi
}

function usage {
  echo
  echo "This is a Bash script template"
  echo "Usage: ./example.sh -l <logfile> -L <loglevel>"
  echo "Example: ./example.sh -l example.log -L INFO"
  echo
}

# Get input parameters
while [[ "$1" != "" ]]; do
  case $1 in
      -L | --loglevel )       shift
                              LOGLEVEL=$1
                              ;;
      -h | --help )           usage
                              exit
                              ;;
     --api-key )              shift
                              APIKEY=$1
                              ;;
     --api-secret )           shift
                              APISECRET=$1
                              ;;
      * )                     usage
                              exit 1
  esac
  shift
done

if [[ ! "$LOGLEVEL" =~ ^(DEBUG|INFO|WARN|ERROR)$ ]]; then
  error "Logging level needs to be DEBUG, INFO, WARN or ERROR."
  exit 1
fi

# generic api function
function requestApi () {
  debug "$1 $2\n$4\n$3"
  resp=$(curl \
    --silent \
    --fail \
    --request "$1" \
    --data    "$3" \
    --header  "$4" \
    --header  "Content-Type: application/json" \
    "https://ethanbayliss.api.openvpn.com/$2")
  debug "Curl exit code: $?"
  debug "$resp"
}

function validateApiCreds {
  while [[ -z "$APIKEY" ]]; do
    info "Missing CloudConnexa API key, create one here: https://openvpn.net/cloud-docs/developer/creating-api-credentials.html\nSpecify with --api-key or environment variable APIKEY"
    read -p 'Enter CloudConnexa API Key: ' APIKEY
  done
  while [[ -z "$APISECRET" ]]; do
    info "Missing CloudConnexa API secret, create one here: https://openvpn.net/cloud-docs/developer/creating-api-credentials.html\nSpecify with --api-secret or environment variable APISECRET"
    read -p 'Enter CloudConnexa API secret: ' APISECRET
  done
}

function getOauthToken {
  #Authorization: Basic [base64({KEY}:{SECRET})]
  #POST https://<yourCLOUDID>.api.openvpn.com/api/v1/oauth/token
  local authHeader="Authorization: Basic $(printf $APIKEY:$APISECRET | base64 --wrap=0)"
  requestApi "POST" "api/beta/oauth/token" "" "$authHeader"
  token=$(echo $resp | jq -r .access_token)
}

# Creates a network in CloudConnexa
# Inputs: 
#   $1: network name
#   $2: network description
#   $3: VPN region (AWS region code)
function createNetwork () {
  local body=$(jq --null-input \
    --arg name "$1" \
    --arg desc "$2" \
    --arg region "$3" \
    --arg connectorName "$1-connector" \
    --arg connectorDesc "Connector for $1" \
    '{
      "name":$name,
      "description":$desc,
      "egress":true,
      "internetAccess":"BLOCKED",
      "connectors":[
        {
          "name":$connectorName,
          "vpnRegionId":$region,
          "description":$connectorDesc
        }
      ],
      "routes":[
        {
          "allowEmbeddedIp": true,
          "description": "Route for infra-aks",
          "value": "10.69.0.0/16"
        }
      ],
      "services":[]
    }'
  )
  requestApi "POST" "api/beta/networks" "$body" "$tokenHeader"
}

# Creates a route in a CloudConnexa network
# Inputs:
#   $1: network ID
#   $2: route description
#   $3: network subnet to route over the VPN (matching vnet for cluster)
function createRoute () {
  local body=$(jq --null-input \
    --arg desc "$2" \
    --arg destination "$3" \
    '{
      "allowEmbeddedIp": true,
      "description": $desc,
      "value": $destination
    }'
  )
  requestApi "POST" "api/beta/networks/$1/routes" "$body" "$tokenHeader"
}

validateApiCreds

info "Logging into CloudConnexa"
getOauthToken # sets $token
tokenHeader="Authorization: Bearer $token"

# Create network
createNetwork "infra-aks" "Network for the infra-aks cluster" "ap-southeast-2"
info "$resp"
networkId=$(echo $resp | jq -r '.id')
debug "$networkId"

# Create network route
createRoute "$networkId" "Route for infra-aks" "10.69.0.0/16"
