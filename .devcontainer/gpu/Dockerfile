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

# Build and install MuJoCo from source with GPU support
ARG MUJOCO_VERSION=main
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

# Set MuJoCo and NVIDIA environment variables for GPU rendering
ENV MUJOCO_DIR=/usr/local \
    LD_LIBRARY_PATH=/usr/local/lib:${LD_LIBRARY_PATH} \
    CMAKE_PREFIX_PATH=/usr/local:${CMAKE_PREFIX_PATH} \
    MUJOCO_GL=glfw \
    NVIDIA_VISIBLE_DEVICES=all \
    NVIDIA_DRIVER_CAPABILITIES=graphics,utility,compute \
    __GL_SYNC_TO_VBLANK=0

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
    # Create video and render groups if they don't exist
    && (getent group video || groupadd video) \
    && (getent group render || groupadd render) \
    && usermod -a -G video,render $USERNAME

USER $USERNAME
WORKDIR /workspaces/cheri

# Set up environment for hardware-accelerated OpenGL with NVIDIA GPU
ENV LIBGL_ALWAYS_INDIRECT=0 \
    __NV_PRIME_RENDER_OFFLOAD=1 \
    __GLX_VENDOR_LIBRARY_NAME=nvidia

RUN echo 'alias ll="ls -lah"' >> ~/.bashrc \
    && echo 'alias gpu-check="nvidia-smi"' >> ~/.bashrc \
    && echo 'alias gl-check="glxinfo | grep -E \"OpenGL vendor|OpenGL renderer|OpenGL version\""' >> ~/.bashrc



