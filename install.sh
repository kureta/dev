#!/bin/bash

nvim --headless "+luafile install.lua" &
myPid=$!
sleep 60
kill $myPid
