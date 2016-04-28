#!/bin/sh

if [[ "$TRAVIS_PULL_REQUEST" != "false" ]]; then
  fastlane adhoc
  exit $?
fi
