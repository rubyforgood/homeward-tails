#!/bin/bash
set -e

# Remove a potentially pre-existing server.pid for Rails.
rm -f /petrescue/tmp/pids/server.pid

if [ "$SERVICE_NAME" = "app" ]; then
  echo "Running db:prepare"
  /petrescue/bin/rails db:prepare
fi

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"
