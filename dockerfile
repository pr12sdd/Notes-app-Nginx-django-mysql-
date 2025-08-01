#stage 1 base image 940mb
FROM python:3.9 AS builder

WORKDIR /app/backend

COPY requirements.txt /app/backend

RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y gcc default-libmysqlclient-dev pkg-config \
    && rm -rf /var/lib/apt/lists/*

RUN pip install mysqlclient

RUN pip install -r requirements.txt

#stage ---------------
#stage 2 base image 140mb
FROM python:3.9-slim
WORKDIR /app/backend

RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y gcc default-libmysqlclient-dev pkg-config \
    && rm -rf /var/lib/apt/lists/*


COPY --from=builder /usr/local/lib/python3.9/site-packages/ /usr/local/lib/python3.9/site-packages/
COPY --from=builder /usr/local/bin/ /usr/local/bin/

COPY . /app/backend

EXPOSE 8000
