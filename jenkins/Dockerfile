# Use the official Jenkins LTS image with JDK 17
FROM jenkins/jenkins:lts-jdk17

# Switch to root to install packages
USER root

# Install basic prerequisites
RUN apt-get update && apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    && rm -rf /var/lib/apt/lists/*

# Add Docker's official GPG key and repository
RUN install -m 0755 -d /etc/apt/keyrings \
    && curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg \
    && chmod a+r /etc/apt/keyrings/docker.gpg

RUN echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian bookworm stable" > /etc/apt/sources.list.d/docker.list

# Install Docker CLI
RUN apt-get update && apt-get install -y docker-ce-cli \
    && rm -rf /var/lib/apt/lists/*

# Add Jenkins user to Docker group (match host Docker GID)
ARG DOCKER_GID=1001
RUN groupadd -g $DOCKER_GID docker \
    && usermod -aG docker jenkins

# Switch back to Jenkins user
USER jenkins


