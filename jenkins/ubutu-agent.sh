
# --- Configuration ---
CONTAINER_NAME="ubuntu-agent"
IMAGE="ubuntu:22.04"
NETWORK="jenkins-net"
WORKDIR="/home/jenkins/agent"

# --- Clean up old container if it exists ---
if docker ps -a --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
    echo "Removing existing container ${CONTAINER_NAME}"
    docker rm -f ${CONTAINER_NAME}
fi

# --- Run Ubuntu container in background with persistent restart ---
docker run -d --name ${CONTAINER_NAME} \
  --network ${NETWORK} \
  --restart unless-stopped \
  -v ${CONTAINER_NAME}_work:${WORKDIR} \
  ${IMAGE} sleep infinity

echo "✅ Ubuntu container '${CONTAINER_NAME}' created and running."