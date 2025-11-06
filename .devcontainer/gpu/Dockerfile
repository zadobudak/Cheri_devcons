FROM nvidia/cuda:12.9.1-devel-ubuntu24.04

ENV DEBIAN_FRONTEND=noninteractive

# Install essential packages
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    git \
    pkg-config \
    sudo \
    wget \
    ninja-build \
    # X11 support
    x11-apps \
    libx11-dev \
    libxrandr-dev \
    libxinerama-dev \
    libxcursor-dev \
    libxi-dev \
    libxxf86vm-dev \
    # Wayland support
    libwayland-dev \
    libxkbcommon-dev \
    # OpenGL & GPU acceleration (NVIDIA-compatible)
    libgl1-mesa-dev \
    libglu1-mesa-dev \
    mesa-utils \
    libglew-dev \
    libglvnd0 \
    libgl1 \
    libglx0 \
    libegl1 \
    libgles2 \
    # NVIDIA OpenGL libraries (provided by base image)
    # MuJoCo build dependencies
    libeigen3-dev \
    libxml2-dev \
    # Tools
    gdb \
    vim \
    glmark2 \
    && rm -rf /var/lib/apt/lists/*


# Create non-root user (reuse existing ubuntu user with UID/GID 1000)
ARG USERNAME=cheri
ARG USER_UID=1000
ARG USER_GID=1000

RUN if getent passwd $USER_UID; then \
        # User with UID exists, rename it
        existing_user=$(getent passwd $USER_UID | cut -d: -f1) && \
        usermod -l $USERNAME -d /home/$USERNAME -m $existing_user; \
    else \
        # Create new user
        groupadd --gid $USER_GID $USERNAME && \
        useradd --uid $USER_UID --gid $USER_GID -m $USERNAME -s /bin/bash; \
    fi \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME \


USER $USERNAME
WORKDIR /workspaces/cheri




