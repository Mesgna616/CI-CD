# Use official Jenkins LTS image
FROM jenkins/jenkins:lts-jdk17

USER root
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y git && \
    rm -rf /var/lib/apt/lists/*

USER jenkins