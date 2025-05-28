#!/bin/bash

input="cam_log.txt"
counter=1

while IFS= read -r line
do
  # Вытаскиваем URL из строки
  url=$(echo "$line" | grep -oP 'http://[^ ]+')

  if [ -n "$url" ]; then
    # Формируем имя файла, подставляем IP и порт в имя
    ip_port=$(echo "$url" | sed -E 's|http://([^/]+).*|\1|' | tr ':' '_')
    filename="snapshot_${ip_port}_${counter}.jpg"
    
    echo "Снимаем с $url -> $filename"
    
    # Запускаем ffmpeg с таймаутом, чтобы не зависать
    timeout 10 ffmpeg -y -i "$url" -vframes 1 "$filename" 2>/dev/null
    
    ((counter++))
  fi
done < "$input"
