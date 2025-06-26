#!/bin/bash

# Config. Url from https://www.talos.dev/v1.10/talos-guides/install/single-board-computers/rpi_generic/
IMAGE_URL="https://factory.talos.dev/image/ee21ef4a5ef808a9b7484cc0dda0f25075021691c8c09a276591eedb638ea1f9/v1.10.0/metal-arm64.raw.xz"
IMAGE_NAME_COMPRESSED=$(basename "$IMAGE_URL")   # metal-arm64.raw.xz
IMAGE_NAME="${IMAGE_NAME_COMPRESSED%.xz}"        # metal-arm64.raw
REMOTE_IMAGE_PATH="/mnt/sdcard/$IMAGE_NAME"


# Check if all required environment variables are set
if [[ -z "${TPI_HOSTNAME}" || -z "${TPI_USERNAME}" || -z "${TPI_PASSWORD}" ]]; then
  echo "Error: One or more required environment variables are not set."
  echo "Please set TPI_HOSTNAME, TPI_USERNAME, and TPI_PASSWORD."
  exit 1
fi

# Download and unpack image just once. We store it on the Pi Turing SD-card
if ! ssh "${TPI_USERNAME}@${TPI_HOSTNAME}" "[ -f '${REMOTE_IMAGE_PATH}' ]" >/dev/null 2>&1; then
    echo "Image does not exist. Downloading..."
    ssh "${TPI_USERNAME}@${TPI_HOSTNAME}" bash -c "'
                set -e
                cd /mnt/sdcard
                curl -LO ${IMAGE_URL}
                echo \"Unpacking...\"
                xz -d ${IMAGE_NAME_COMPRESSED}
    '" || {
        echo "Error with downloading/unpacking image!"
        exit 1
    }
fi

# Flash and reboot nodes
for NODE in {1..4}; do
    echo "Flashing node $NODE..."
    if ! tpi flash -n "$NODE" --local --image-path "${REMOTE_IMAGE_PATH}"; then
        echo "Flashing of $NODE has failed!"
    fi

    # Reset doesn't seem to work always, so turn it off and on instead
    tpi power -n "$NODE" off
    tpi power -n "$NODE" on
done
