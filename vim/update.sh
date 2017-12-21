#!/bin/bash

find bundle -maxdepth 1 -mindepth 1 -type d -exec sh -c 'cd "$1" && git pull' _ {} \;
