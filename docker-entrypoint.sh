#!/bin/bash

ENVOY_BOOTSTRAP_CONFIG="/etc/envoy/envoy.yaml"
ENVOY_CLUSTERS_CONFIG="/etc/envoy/clusters.yaml"
ENVOY_LISTENERS_CONFIG="/etc/envoy/listeners.yaml"

if [ -f "$ENVOY_BOOTSTRAP_CONFIG" ]; then
  export DOGSTATSD_ADDRESS=${DOGSTATSD_ADDRESS:-'127.0.0.1'}
  export DOGSTATSD_PORT=${DOGSTATSD_PORT:-'8125'}
  export DOGSTATSD_PROTOCOL=${DOGSTATSD_PROTOCOL:-'UDP'}

  tmp=$(mktemp)

  # shellcheck disable=SC2016
  envsubst '
    $DOGSTATSD_ADDRESS
    $DOGSTATSD_PORT
    $DOGSTATSD_PROTOCOL
  ' < "$ENVOY_BOOTSTRAP_CONFIG" > "$tmp"

  cp "$tmp" "$ENVOY_BOOTSTRAP_CONFIG"
  rm "$tmp"

  echo "Substituted values with environment variables in $ENVOY_BOOTSTRAP_CONFIG"
fi

if [ -f "$ENVOY_CLUSTERS_CONFIG" ]; then
  export UPSTREAM_HOST=${UPSTREAM_HOST:-'5ff35ccd28c3980017b193a2.mockapi.io'}
  export UPSTREAM_PORT=${UPSTREAM_PORT:-'80'}

  tmp=$(mktemp)

  # shellcheck disable=SC2016
  envsubst '
    $UPSTREAM_HOST
    $UPSTREAM_PORT
  ' < "$ENVOY_CLUSTERS_CONFIG" > "$tmp"

  cp "$tmp" "$ENVOY_CLUSTERS_CONFIG"
  rm "$tmp"

  echo "Substituted values with environment variables in $ENVOY_CLUSTERS_CONFIG"
fi

if [ -f "$ENVOY_LISTENERS_CONFIG" ]; then
  echo "Substituted values with environment variables in $ENVOY_LISTENERS_CONFIG"
fi

# if the first argument look like a parameter (i.e. start with '-'), run Envoy
if [ "${1#-}" != "$1" ]; then
  set -- envoy "$@"
fi

if [ "$1" = 'envoy' ]; then
  # set the log level if the $loglevel variable is set
  if [ -n "$loglevel" ]; then
    set -- "$@" --log-level "$loglevel"
  fi
fi

exec "$@"
