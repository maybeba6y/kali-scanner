FROM kalilinux/kali-rolling

RUN apt-get update && apt-get install -y --no-install-recommends \
    kali-linux-headless \
    nmap \
    curl \
    ffmpeg \
    iproute2 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

USER root
WORKDIR /root