#!/bin/bash

nvim --headless "+luafile install.lua" &
myPid=$!
sleep 90
kill $myPid
