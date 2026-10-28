#!/bin/bash

sudo -v || return 1
  set +x
  (
    while true; do
      sudo -n true
      sleep 60
    done
  ) 2>/dev/null &
  echo "sudo session will be kept alive in the background (PID $!)."

#this script allows you to keep enabling/turning sudo on as long as you open bash. if bash is closed then so is this script
