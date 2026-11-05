# One Dockerfile, two images:
#   robot -> ros:lyrical-ros-base           (amd64 + arm64, runs on the laptop AND the Pi)
#   sim   -> osrf/ros:lyrical-desktop-full  (laptop only: adds RViz, Gazebo Jetty, ros_gz)
# compose.yaml picks which one by passing BASE_IMAGE.

ARG BASE_IMAGE=ros:lyrical-ros-base
FROM ${BASE_IMAGE}

ARG EXTRA_APT_PACKAGES=""
ARG USERNAME=ros
ARG USER_UID=1000
ENV DEBIAN_FRONTEND=noninteractive

# Tools + Nav2. Anything both machines need goes here.
RUN apt-get update && apt-get install -y --no-install-recommends \
        sudo git nano less bash-completion usbutils \
        python3-colcon-common-extensions python3-rosdep python3-vcstool \
        ros-${ROS_DISTRO}-navigation2 \
        ros-${ROS_DISTRO}-nav2-bringup \
        ${EXTRA_APT_PACKAGES} \
    && rm -rf /var/lib/apt/lists/*

# Non-root user with the same UID as your login on the laptop and the Pi (1000),
# so files created inside the container are owned by you on the host.
RUN if id -u ubuntu >/dev/null 2>&1; then userdel -r ubuntu || true; fi \
    && useradd -m -s /bin/bash -u ${USER_UID} ${USERNAME} \
    && groupadd -f plugdev && groupadd -f render \
    && usermod -aG dialout,video,plugdev,render ${USERNAME} \
    && echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/${USERNAME} \
    && chmod 0440 /etc/sudoers.d/${USERNAME}

# Workspace. build/install/log are pre-created so the named volumes inherit ownership.
RUN mkdir -p /ws/src /ws/build /ws/install /ws/log \
    && chown -R ${USERNAME}:${USERNAME} /ws

COPY docker/entrypoint.sh /entrypoint.sh
COPY docker/rbuild /usr/local/bin/rbuild
RUN chmod +x /entrypoint.sh /usr/local/bin/rbuild

# Every new shell (including `docker compose exec ... bash`) gets ROS + your workspace.
RUN echo 'source /opt/ros/${ROS_DISTRO}/setup.bash' >> /home/${USERNAME}/.bashrc \
    && echo '[ -f /ws/install/setup.bash ] && source /ws/install/setup.bash' >> /home/${USERNAME}/.bashrc

USER ${USERNAME}
RUN (sudo rosdep init 2>/dev/null || true) && rosdep update --rosdistro ${ROS_DISTRO}

WORKDIR /ws
ENTRYPOINT ["/entrypoint.sh"]
CMD ["bash"]
