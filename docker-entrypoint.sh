#!/bin/bash
set -e

case "$1" in
  start )
    puma -b tcp://0.0.0.0:${APP_PORT:-80} -w 2
    ;;
  test )
    rspec
    ;;
  * )
    "$@"
    ;;
esac
