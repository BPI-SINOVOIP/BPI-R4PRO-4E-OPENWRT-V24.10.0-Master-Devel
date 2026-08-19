# `BUILD`

Verified to work on `Ubuntu 26.04 LTS (Resolute Raccoon) (x86_64)`:

```sh
sudo apt install -yq docker.io
sudo systemctl enable --now docker
sudo systemctl start  --now docker
# Setup Docker (refer to the instructions on the website or elsewhere if the below doesn't work for you):
echo docker | xargs -n 1 sudo groupadd || echo 'group already exists'
sudo usermod --append --groups docker "$(whoami)" || echo 'already part of `docker` group'
# Restart, logout or use `newgrp docker` before running the `docker` command below.
```

```sh
git clone https://github.com/mbana/BPI-R4PRO-4E-OPENWRT-V24.10.0-Master-Devel.git
cd BPI-R4PRO-4E-OPENWRT-V24.10.0-Master-Devel
docker run -it --env FORCE_UNSAFE_CONFIGURE=1 --workdir /work -v .:/work --name bpi-r4-pro-4e ubuntu:20.04
# In the container run the below commands:
./build.sh
```

The final flashable files will be located under the `bin/targets/mediatek/filogic/` directory:

```sh
$ ls -lah bin/targets/mediatek/filogic/
total 1.1G
drwxr-xr-x 3 root root 4.0K Aug  7 15:07 .
drwxr-xr-x 3 root root 4.0K Aug  5 03:05 ..
-rw-r--r-- 1 root root  17K Aug  7 14:56 config.buildinfo
-rw-r--r-- 1 root root  740 Aug  7 14:56 feeds.buildinfo
-rw-r--r-- 1 root root 167M Aug  7 15:07 kernel-debug.tar.zst
-rw-r--r-- 1 root root 234K Aug  5 03:54 mt7988-ram-comb-bl2.bin
-rw-r--r-- 1 root root 1.1M Aug  7 15:10 openwrt-mediatek-filogic-bananapi_bpi-r4-pro-4e-emmc-bl31-uboot.fip
-rw-r--r-- 1 root root  17K Aug  7 15:10 openwrt-mediatek-filogic-bananapi_bpi-r4-pro-4e-emmc-gpt.bin
-rw-r--r-- 1 root root 245K Aug  7 15:10 openwrt-mediatek-filogic-bananapi_bpi-r4-pro-4e-emmc-preloader.bin
-rw-r--r-- 1 root root 211M Aug  7 15:10 openwrt-mediatek-filogic-bananapi_bpi-r4-pro-4e-emmc.img.gz
-rw-r--r-- 1 root root  88M Aug  7 15:10 openwrt-mediatek-filogic-bananapi_bpi-r4-pro-4e-initramfs-recovery.itb
-rw-r--r-- 1 root root 212M Aug  7 15:10 openwrt-mediatek-filogic-bananapi_bpi-r4-pro-4e-sdcard.img.gz
-rw-r--r-- 1 root root 1.1M Aug  7 15:10 openwrt-mediatek-filogic-bananapi_bpi-r4-pro-4e-snand-bl31-uboot.fip
-rw-r--r-- 1 root root 225M Aug  7 15:10 openwrt-mediatek-filogic-bananapi_bpi-r4-pro-4e-snand-factory.bin
-rw-r--r-- 1 root root 257K Aug  7 15:10 openwrt-mediatek-filogic-bananapi_bpi-r4-pro-4e-snand-preloader.bin
-rw-r--r-- 1 root root 123M Aug  7 15:10 openwrt-mediatek-filogic-bananapi_bpi-r4-pro-4e-squashfs-sysupgrade.itb
-rw-r--r-- 1 root root  15K Aug  7 15:10 openwrt-mediatek-filogic.manifest
drwxr-xr-x 3 root root  20K Aug  7 15:03 packages
-rw-r--r-- 1 root root 3.8K Aug  7 15:10 profiles.json
-rw-r--r-- 1 root root 1.9K Aug  7 15:11 sha256sums
-rw-r--r-- 1 root root   12 Aug  7 14:56 version.buildinfo
```

So just run the below replacing `/dev/sdd` with the path of the actual micro SD card:

```sh
$ gunzip --stdout --keep bin/targets/mediatek/filogic/openwrt-mediatek-filogic-bananapi_bpi-r4-pro-4e-sdcard.img.gz | sudo dd status=progress conv=notrunc,fsync of=/dev/sdd
```

## Notes

### Build failures

If the [`./build.sh`](./build.sh) command fails about missing firmware, re-run everything using a single thread like so:

```sh
make package/firmware/linux-firmware/compile -j1 V=sc
make -j1 V=sc
```

### Don't lose your work or build

If for whatever reason you loose the Docker shell, you simply need to run the following to get back into it (so your build isn't lost):

```sh
docker start bpi-r4-pro-4e
docker exec -it bpi-r4-pro-4e bash
# Inside the container run:
cd /work
./build.sh
```

## Additional packages

See [`./PACKAGES.md`](./PACKAGES.md).
