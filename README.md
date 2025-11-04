# Cheri Devcontainers

Docker-based development containers for the Cheri Project that provide a consistent build and runtime environment.


## Requirements

- Docker installed natively on the host (Docker Desktop not recommended due to VM display forwarding limitations)
- xhost for X11 display forwarding (works with X11 and XWayland)

Tested on Arch Linux (LTS kernel, x86_64).

## Project Structure

The `cheri-control` and `rtrobot` repositories are included as submodules. Additional repositories can be added similarly.

To clone these repositories you need to have ssh access to the repositories.

## Usage

Clone the repository with submodules:
```bash
git clone https://github.com/zadobudak/Cheri_devcons.git

cd Cheri-devcons

git submodule init
git submodule update

code .
```

Press F1 and select "Remote-Containers: Rebuild and Reopen in Container".

Build the project using tasks defined in `.vscode/tasks.json`.

## Available Containers

Two main devcontainer configurations are provided in with option with local build and direct pull from ghcr 

Configurations are under `.devcontainer/`:
- CPU : Software rendering
- GPU: NVIDIA CUDA with hardware acceleration


## TODO
- [ ] Test in Ubuntu, Debian etc. 
- [ ] Test for different architectures.
- [ ] Test for devcontainer tool from npm so that it is possible to use it without vscode.
- [x] Publish devcontainer images to GitHub Container Registry
- [x] Add GitHub Actions workflow to build and publish containers 
- [ ] Test display forwarding with Windows if it is possible.
- [ ] Test display forwarding with MacOS if it is possible.
  
