FROM alpine:3.16

RUN apk add --no-cache \
    python3=3.10.9-r0 \
    py3-pip=22.1.1-r0

COPY requirements.txt /requirements.txt

RUN python3 -m pip install --no-cache-dir -r /requirements.txt && \
    rm /requirements.txt

COPY assets/ /opt/resource/
