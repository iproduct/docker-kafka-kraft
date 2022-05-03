FROM openjdk:8u292-slim-buster

WORKDIR /opt

ARG kafkaversion=3.1.0
ARG scalaversion=2.13

ENV KRAFT_CONTAINER_HOST_NAME=kafka
ENV KRAFT_CREATE_TOPICS=events,temperature
ENV KRAFT_PARTITIONS_PER_TOPIC=12

RUN apt update \
    && apt install -y --no-install-recommends wget

RUN wget https://mirrors.ocf.berkeley.edu/apache/kafka/${kafkaversion}/kafka_${scalaversion}-${kafkaversion}.tgz -O kafka.tgz \
    && tar xvzf kafka.tgz \
    && mv kafka_${scalaversion}-${kafkaversion} kafka

WORKDIR /opt/kafka

COPY ./configs/server.properties ./config/kraft
COPY ./*.sh /opt/kafka/

EXPOSE 9092 9093

ENTRYPOINT [ "./docker-entrypoint.sh" ]
