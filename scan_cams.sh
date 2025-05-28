#!/bin/bash

IP_FILE="nmap_results.txt"
URI_FILE="uris.txt"
LOG_FILE="cam_log.txt"

> "$LOG_FILE"  # очистка предыдущего лога

current_ip=""
while IFS= read -r line; do
  # Если строка содержит IP (начинается с "Nmap scan report for")
  if [[ "$line" =~ ^Nmap\ scan\ report\ for\ ([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+) ]]; then
    current_ip="${BASH_REMATCH[1]}"
  fi

  # Если строка содержит открытый порт
  if [[ "$line" =~ ^([0-9]+)/tcp[[:space:]]+open ]]; then
    port="${BASH_REMATCH[1]}"

    # Для каждого URI проверяем полный URL
    while IFS= read -r uri; do
      full_url="http://${current_ip}:${port}/${uri}"
      echo "Проверка $full_url"

      status=$(curl -m 2 -s -I "$full_url" | grep -i "HTTP/")
      if [[ "$status" == *"200 OK"* || "$status" == *"401 Authorization Required"* || "$status" == *"501 Not Implemented"* ]]; then
        echo "[+] Потенциальная камера: $full_url" | tee -a "$LOG_FILE"
        # Можно раскомментировать для ffprobe (если установлен)
        # ffprobe -hide_banner "$full_url"
      fi
    done < "$URI_FILE"
  fi
done < "$IP_FILE"

echo "Сканирование завершено. Результаты сохранены в $LOG_FILE"
