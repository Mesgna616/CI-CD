#!/bin/bash
set -euo pipefail

WORKDIR="/home/jenkins/agent"
JENKINS_URL="http://my-jenkins:8080"
AGENT_NAME="ubuntu-agent"
AGENT_SECRET="3b1ed06b59a13b5b053fafbf4894b8337041a785f17dfe2b6feeb46df7a77dc7"

apt-get update && apt-get install -y openjdk-17-jre-headless curl ca-certificates gnupg && rm -rf /var/lib/apt/lists/*
mkdir -p "$WORKDIR"
curl -fsSL "$JENKINS_URL/jnlpJars/agent.jar" -o "$WORKDIR/agent.jar"
echo "$AGENT_SECRET" > "$WORKDIR/secret-file"

java -jar "$WORKDIR/agent.jar" -url "$JENKINS_URL/" -secret @"$WORKDIR/secret-file" -name "$AGENT_NAME" -webSocket -workDir "$WORKDIR"
