FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

# Install essential packages
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    git \
    ninja-build \
    sudo \
    # X11 libraries for GLFW
    libx11-dev \
    libxrandr-dev \
    libxinerama-dev \
    libxcursor-dev \
    libxi-dev \
    # Wayland support for GLFW
    libwayland-dev \
    libxkbcommon-dev \
    # OpenGL for software rendering
    libglu1-mesa-dev \
    # MuJoCo dependencies
    libeigen3-dev \
    libxml2-dev \
    # Development tools
    gdb \
    vim \
    && rm -rf /var/lib/apt/lists/*

# Build and install MuJoCo from source (CPU-only, software rendering)
ARG MUJOCO_VERSION=3.3.7

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
    && ninja -j$(nproc) \
    && ninja install -j$(nproc) \
    && rm -rf /tmp/mujoco

# Set MuJoCo environment variables for CPU/software rendering
ENV MUJOCO_DIR=/usr/local \
    LD_LIBRARY_PATH=/usr/local/lib:${LD_LIBRARY_PATH} \
    CMAKE_PREFIX_PATH=/usr/local:${CMAKE_PREFIX_PATH} \
    MUJOCO_GL=glfw

# Create non-root user
ARG USERNAME=cheri
ARG USER_UID=1000
ARG USER_GID=1000

RUN if getent passwd $USER_UID; then \
        existing_user=$(getent passwd $USER_UID | cut -d: -f1) && \
        usermod -l $USERNAME -d /home/$USERNAME -m $existing_user; \
    else \
        groupadd --gid $USER_GID $USERNAME && \
        useradd --uid $USER_UID --gid $USER_GID -m $USERNAME -s /bin/bash; \
    fi \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

USER $USERNAME
WORKDIR /workspaces/cheri
