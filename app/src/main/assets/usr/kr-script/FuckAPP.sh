#!/bin/bash

while true; do
    clear
    pkill $package
    echo 执行成功通知
    sleep $s
done