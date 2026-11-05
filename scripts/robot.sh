#!/bin/bash
# Laptop or Pi: start the robot container (if it isn't running) and open a shell in it.
cd "$(dirname "$0")/.."
docker compose up -d robot
docker compose exec robot bash
