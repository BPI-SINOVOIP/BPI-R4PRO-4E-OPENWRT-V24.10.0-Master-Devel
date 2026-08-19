#!/usr/bin/env bash
set -x

# Required when building within a Docker/Podman container, otherwise an error occurs during the build process:
export DEBIAN_FRONTEND='noninteractive'
apt update -yq
apt install -yq \
    build-essential \
    clang \
    flex \
    bison \
    g++ \
    gawk \
    gcc-multilib \
    g++-multilib \
    gettext \
    git \
    libncurses-dev \
    libncurses5-dev \
    libssl-dev \
    python3 \
    python3-dev \
    python3-distutils \
    python3-setuptools \
    python-is-python3 \
    rsync \
    swig \
    unzip \
    zlib1g-dev \
    file \
    wget \
    libslang2-dev \
    libslang2 \
    systemtap-sdt-dev \
    systemtap \
    systemtap-common \
    libperl-dev \
    libelf-dev \
    libdw-dev \
    libunwind-dev \
    libnuma-dev \
    libcap-dev \
    libbabeltrace-dev \
    liblzma-dev \
    libzstd-dev \
	zstd \
	curl

git config --global --add safe.directory /work

./scripts/feeds update -a
./scripts/feeds install -a

export FORCE_UNSAFE_CONFIGURE=1

# Reuse the `.config` supplied in this repository:
make defconfig

make download -j$(nproc) V=sc
make toolchain/install -j$(nproc) V=sc

make package/firmware/linux-firmware/compile -j1 V=sc

rm -rf feeds/packages/lang/golang
git clone https://github.com/kenzok8/golang -b 1.26 feeds/packages/lang/golang
./scripts/feeds update -a && ./scripts/feeds install -a

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source ~/.cargo/env
rustup target add aarch64-unknown-linux-musl

# This might fail, see `./BUILD.md` for details on how to fix it:
make -j$(nproc) V=sc || (make package/firmware/linux-firmware/compile -j1 V=sc && make -j1 V=sc)
