#!/bin/bash
set -euo pipefail

# --- Configuration ---
CONTAINER_NAME="ubuntu-agent"
JENKINS_URL="http://my-jenkins:8080"
AGENT_NAME="ubuntu-agent"
AGENT_LABEL="ubuntu"
# Use a secret from an environment variable
AGENT_SECRET="${JENKINS_AGENT_SECRET}"
WORKDIR="/home/jenkins/agent"

# Check if the secret environment variable is set
if [ -z "${AGENT_SECRET}" ]; then
  echo "Error: JENKINS_AGENT_SECRET environment variable is not set."
  exit 1
fi

# --- Install Java and prerequisites inside container ---
echo "Installing Java and prerequisites..."
docker exec "${CONTAINER_NAME}" bash -c "
  apt-get update -qq && \
  apt-get install -y --no-install-recommends openjdk-17-jre-headless curl gnupg && \
  rm -rf /var/lib/apt/lists/*
"

# --- Verify Java installation ---
echo "Verifying Java installation..."
docker exec "${CONTAINER_NAME}" java -version

# --- Create workspace inside container ---
echo "Creating agent workspace..."
docker exec "${CONTAINER_NAME}" mkdir -p "${WORKDIR}"

# --- Launch the agent ---
echo "Launching the Jenkins agent..."
docker exec -d "${CONTAINER_NAME}" bash -c "
  echo \"${AGENT_SECRET}\" > \"${WORKDIR}/secret-file\" && \
  curl -sSL \"${JENKINS_URL}/jnlpJars/agent.jar\" -o \"${WORKDIR}/agent.jar\" && \
  java -jar \"${WORKDIR}/agent.jar\" \
    -url \"${JENKINS_URL}/\" \
    -secret @\"${WORKDIR}/secret-file\" \
    -name \"${AGENT_NAME}\" \
    -webSocket \
    -workDir \"${WORKDIR}\"
"

echo "✅ Ubuntu agent '${AGENT_NAME}' connected to Jenkins master."