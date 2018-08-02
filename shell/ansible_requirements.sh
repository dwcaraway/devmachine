#!/bin/bash
#
# Install packages to allow ansible local to run
if command -v git; then
    exit 0
fi

if command -v apt-get; then
    apt-get install -y git > /dev/null
elif command -v yum; then
    yum install -y git > /dev/null
else
    print "Unsupported operating system"
    exit 1
fi
