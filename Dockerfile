FROM openjdk:8u292-slim-buster

WORKDIR /opt

ARG kafkaversion=3.1.0
ARG scalaversion=2.13

ENV KAFKA_CONTAINER_HOST_NAME=
ENV BOOTSTRAP_SERVERS=localhost:9093
ENV BROKER_ID=1
ENV BROKER_EXTERNAL_PORT=9093
ENV CONTROLLER_QUORUM_VOTERS=1@localhost:19092
ENV KAFKA_CREATE_TOPICS=
ENV KAFKA_PARTITIONS_PER_TOPIC=1
ENV KAFKA_PARTITIONS_REPLICATION_FACTOR=1
#ENV BROKER_IP=172.28.0.2



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
