#!/bin/bash

# 設定區
domain="https://active.cyut.edu.tw" # 要檢查的網址
http_code="200"                     # 要檢查的 HTTP 狀態碼
time_out_sec=1                      # 設定超時秒數

# 初始化計數器
success_count=0
failure_count=0

# 顏色設定
RED="\033[1;31m"
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
BLUE="\033[1;34m"
WHITE="\033[0m"

# 無窮循環
echo -e "\n開始檢查連線 ..."
echo -e "檢查網址: ${BLUE}${domain}${WHITE}"
echo -e "檢查 HTTP 狀態碼: ${BLUE}${http_code}${WHITE}\n"

while true; do
    # 執行 curl 命令，並將輸出回應的 HTTP 狀態碼
    response=$(curl -s -o /dev/null -w "%{http_code}" -I -m ${time_out_sec} ${domain})
    if echo "$response" | grep ${http_code} 1>/dev/null; then
        ((success_count++))
        echo -e "$(date +"%T") - ${GREEN}連線成功 (HTTP 狀態碼: ${http_code})${WHITE}"
    else
        # 如果沒有找到，增加計數器，並印出 HTTP 狀態碼
        ((failure_count++))
        echo -e "$(date +"%T") - ${RED}連線失敗${WHITE} - 失敗次數: ${YELLOW}$failure_count${WHITE} - HTTP 狀態碼: ${BLUE}$response${WHITE}"
    fi

    if [ $(((failure_count + success_count) % 10)) -eq 0 ]; then
        echo -e "\n成功次數: ${GREEN}${success_count}${WHITE} - 失敗次數: ${RED}${failure_count}${WHITE} - 總共次數: ${BLUE}$((failure_count + success_count))${WHITE}\n"
    fi
done
