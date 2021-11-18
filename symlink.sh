#!bin/bash

cd /lib/modules/4.19.102-std-def-alt1/nVidia
rm -r nvidia*
ln -s /lib/modules/nvidia/drm-4.19.102-std-def-alt1-390.132 /lib/modules/4.19.102-std-def-alt1/nVidia/nvidia-drm.ko
ln -s /lib/modules/nvidia/4.19.102-std-def-alt1-390.132 /lib/modules/4.19.102-std-def-alt1/nVidia/nvidia.ko
ln -s /lib/modules/nvidia/modeset-4.19.102-std-def-alt1-390.132 /lib/modules/4.19.102-std-def-alt1/nVidia/nvidia-modeset.ko
ln -s /lib/modules/nvidia/uvm-4.19.102-std-def-alt1-390.132 /lib/modules/4.19.102-std-def-alt1/nVidia/nvidia-uvm.ko

