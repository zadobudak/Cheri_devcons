FROM ubuntu:24.04

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
    # OpenGL (software rendering via Mesa)
    libgl1-mesa-dev \
    libglu1-mesa-dev \
    mesa-utils \
    libglew-dev \
    libegl1 \
    libgles2 \
    # MuJoCo build dependencies
    libeigen3-dev \
    libxml2-dev \
    # Tools
    gdb \
    vim \
    && rm -rf /var/lib/apt/lists/*

# Build and install MuJoCo from source (CPU-only, software rendering)
ARG MUJOCO_VERSION=3.3.7
ENV MUJOCO_VERSION=${MUJOCO_VERSION}

RUN git clone --depth 1 --branch ${MUJOCO_VERSION} https://github.com/google-deepmind/mujoco.git /tmp/mujoco \
    && cd /tmp/mujoco \
    && mkdir build \
    && cd build \
    && cmake .. \
        -G Ninja \
        -DCMAKE_INSTALL_PREFIX=/usr/local \
        -DCMAKE_BUILD_TYPE=Release \
        -DMUJOCO_BUILD_EXAMPLES=OFF \
        -DMUJOCO_BUILD_SIMULATE=ON \
        -DMUJOCO_BUILD_TESTS=OFF \
        -DMUJOCO_BUILD_PYTHON=OFF \
        -DMUJOCO_ENABLE_AVX=ON \
        -DMUJOCO_ENABLE_AVX_INTRINSICS=ON \
    && ninja \
    && ninja install \
    && rm -rf /tmp/mujoco

# Set MuJoCo environment variables for CPU/software rendering
ENV MUJOCO_DIR=/usr/local \
    LD_LIBRARY_PATH=/usr/local/lib:${LD_LIBRARY_PATH} \
    CMAKE_PREFIX_PATH=/usr/local:${CMAKE_PREFIX_PATH} \
    MUJOCO_GL=glfw

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
    && chmod 0440 /etc/sudoers.d/$USERNAME

USER $USERNAME
WORKDIR /workspaces/cheri

# Set up environment for software-rendered OpenGL
ENV LIBGL_ALWAYS_INDIRECT=0




