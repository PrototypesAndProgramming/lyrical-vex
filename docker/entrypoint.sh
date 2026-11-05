#!/bin/bash
# Runs every time a container starts: load ROS, then your workspace if it has been built.
set -e
source "/opt/ros/${ROS_DISTRO}/setup.bash"
if [ -f /ws/install/setup.bash ]; then
    source /ws/install/setup.bash
fi
exec "$@"
