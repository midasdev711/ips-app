#!/bin/bash
set -e

case "$1" in
  start )
    rake db:migrate
    puma -b tcp://0.0.0.0:${APP_PORT:-8000} -w 2
    ;;
  test )
    rspec
    ;;
  * )
    "$@"
    ;;
esac
