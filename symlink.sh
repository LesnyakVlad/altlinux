#!bin/bash
sh kernel.sh
cd /etc/modprobe.d/
rm -f blacklist-video.conf
touch blacklist-video.conf
echo "blacklist nouveau" >> blacklist-video.conf

cd /lib/modules/4.19.102-std-def-alt1/nVidia
rm -f nvidia*
ln -s /lib/modules/nvidia/drm-4.19.102-std-def-alt1-390.132 /lib/modules/4.19.102-std-def-alt1/nVidia/nvidia-drm.ko
ln -s /lib/modules/nvidia/4.19.102-std-def-alt1-390.132 /lib/modules/4.19.102-std-def-alt1/nVidia/nvidia.ko
ln -s /lib/modules/nvidia/modeset-4.19.102-std-def-alt1-390.132 /lib/modules/4.19.102-std-def-alt1/nVidia/nvidia-modeset.ko
ln -s /lib/modules/nvidia/uvm-4.19.102-std-def-alt1-390.132 /lib/modules/4.19.102-std-def-alt1/nVidia/nvidia-uvm.ko

