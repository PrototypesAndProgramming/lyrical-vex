#!/bin/bash
# Laptop only: allow containers to open windows, start the sim container, drop into a shell.
# Run it again in another terminal to get a second shell in the same container.
cd "$(dirname "$0")/.."
xhost +local: >/dev/null
docker compose up -d sim
docker compose exec sim bash
