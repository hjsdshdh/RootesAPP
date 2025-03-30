#!/bin/bash

# 参数
SO_FILE="$1"
ENCRYPTED_FILE="$2"

# 加密操作
openssl enc -aes-256-cbc -salt -in "$SO_FILE" -out "$ENCRYPTED_FILE" -pass pass:pado46467%+-/
