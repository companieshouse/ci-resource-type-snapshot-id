FROM alpine:3.16

RUN apk add --no-cache \
    python3=3.10.5-r0 \
    py3-pip=22.1.1-r0

COPY requirements.yml /requirements.yml

RUN python3 -m pip install --no-cache-dir -r /requirements.yml && \
    rm /requirements.yml

COPY assets/ /opt/resource/
