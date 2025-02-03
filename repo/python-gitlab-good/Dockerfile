### Dockerfile
#
#   See https://github.com/russmckendrick/docker-python-web-app

FROM alpine:latest

LABEL maintainer="Russ McKendrick <russ@mckendrick.io>"
LABEL org.opencontainers.image.source https://github.com/russmckendrick/docker-python-web-app/
LABEL org.opencontainers.image.description "Docker Image with a sample flask app for testing deployments"

RUN apk update && apk upgrade && \
    apk add bash py3-pip python3 && \
    ln -sf python3 /usr/bin/python && \
    pip install --break-system-packages -r https://raw.githubusercontent.com/russmckendrick/docker-python-web-app/master/requirements.txt && \
    mkdir /app

COPY app.py /app
WORKDIR /app
ENTRYPOINT ["python"]
CMD ["app.py"]