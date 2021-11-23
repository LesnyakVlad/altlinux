#! /bin/bash
lsblk
echo -----------
timedatectl set-ntp yes
newhome="/home."$(date '+%s')
fdisk -l | grep "Disk model" -B 1
UPD_VER=$(ls /archive | grep alt-system | grep -Eo '[0-9].[0-9].[0-9]{1,4}')
UPD_ALT=$(ls /archive | grep alt-system)
bootnow=$(lsblk -l|grep boot|cut -c -3)
echo -en "\033[96mNow system boot on disk" $bootnow "\033[0m\n"

## start detect EFI
    mkdir /mnt/tmp2
    for i in $(ls /dev|grep sd|grep -v $bootnow|awk 'FNR>1')
    do
    mkdir /mnt/tmp2/$i
    mount /dev/$i /mnt/tmp2/$i 2>/dev/null
        if [[ "$(ls -d /mnt/tmp2/$i/*/ 2>/dev/null|grep -iE efi)" ]] && ! [[ "$(ls -d /mnt/tmp2/$i/*/ 2>/dev/null|grep -iE recovery)" ]] && ! [[ "$(ls /mnt/tmp2/$i/ 2>/dev/null|grep -iE vmlinuz)" ]]; then
        echo -en "\033[96mEFI detected on "$i"\033[0m\n"
        efipart=$i
        fi
    umount /mnt/tmp2/$i 2>/dev/null
    rmdir /mnt/tmp2/$i
    done
    rmdir /mnt/tmp2
## end detect EFI

## start compare install mode system and bootable USB flash drive
        if [[ -d "/sys/firmware/efi" && -n "$efipart" ]]; then :
        else
            if [[ ! -d "/sys/firmware/efi" && -z "$efipart" ]]; then :
            else
                echo -en "\033[31mInstalled system and bootable USB flash drive in different modes (UEFI/Legacy)\033[0m\n"
                exit 1
            fi
        fi
## end compare install mode system and bootable USB flash drive

echo -en "\033[92mRun update to alt "$UPD_VER" yes/no\033[0m\n"
read install
if [[ "$install" == "yes" || "$install" == "y" ]]; then

##  echo "Select the drive with linux. Example sda,sdb,sdc ...."
##  read DISK
  echo "Checking /archive/$UPD_ALT"
#  pv /archive/$UPD_ALT | tar -I zstdmt -t   > /dev/null
  CHECK_TAR=$?
  if [[ $CHECK_TAR = 0 ]]; then
    if [ -d '/sys/firmware/efi' ]
    then
      bootp=$( (fdisk -l|grep 1000M|grep Linux|awk 'NR==1{print $1}'))
      rootp=$( (fdisk -l|grep Linux|grep G|grep ${bootp::-1}|awk '/./{line=$0} END{print line}'|awk '{print $1}'))
      mount $rootp /mnt
      mount $bootp /mnt/boot
        mount /dev/$efipart /mnt/boot/efi
        mkdir /home/tmp2
        cp /mnt/etc/sysconfig/grub2 /home/tmp2
        cp -R /mnt/etc/cups/ /home/tmp2
        cp -R /mnt/etc/NetworkManager/system-connections /home/tmp2
        cp /mnt/etc/fstab /home/tmp2
        cp /mnt/etc/hostname /home/tmp2
        cp /mnt/etc/X11/sddm/sddm.conf /home/tmp2
        cp /mnt/etc/rc.d/rc.local /home/tmp2 2>/dev/null
        cp -R /mnt/usr/share/templates/ /home/tmp2
        cp -R /mnt/usr/share/applications/ /home/tmp2
        rm -rf /mnt/etc
        mv /mnt/home /mnt$newhome
      echo "Unpacking /archive/$UPD_ALT"
      pv /archive/$UPD_ALT | tar -I zstdmt --numeric-owner -xp -C /mnt/ --exclude={'proc','dev','sys','mnt','etc/sysconfig/grub2','etc/cups','etc/fstab','etc/hostname','home/user/Документы','home/user/Загрузки','home/user/Общедоступные','home/user/Рабочий стол'}
        cp /home/tmp2/grub2 /mnt/etc/sysconfig/
        /bin/cp -Rf /home/tmp2/cups /mnt/etc/
        /bin/cp -Rf /home/tmp2/system-connections /mnt/etc/NetworkManager/
        cp /home/tmp2/fstab /mnt/etc/
        cp /home/tmp2/hostname /mnt/etc/
        cp /home/tmp2/sddm.conf /mnt/etc/X11/sddm/
        cp /home/tmp2/rc.local /mnt/etc/rc.d/ 2>/dev/null
        /bin/cp -Rf /home/tmp2/templates /mnt/usr/share/
        /bin/cp -Rf /home/tmp2/applications /mnt/usr/share/
        rm -rf /home/tmp2
        echo "Move old soft and home dir"
        rm -rf /mnt/home/user/.PlayOnLinux 2>/dev/null
        mv -f /mnt$newhome/user/.PlayOnLinux /mnt/home/user/ 2>/dev/null
        rm -rf /mnt/home/user/.local 2>/dev/null
        mv -f /mnt$newhome/user/.local /mnt/home/user/ 2>/dev/null
        rm -rf /mnt/home/user/.wine/drive_c/'Program Files'/ASCON 2>/dev/null
        mv -f /mnt$newhome/user/.wine/drive_c/'Program Files'/ASCON /mnt/home/user/.wine/drive_c/'Program Files'/ 2>/dev/null
        rm -rf /mnt/home/user/.winemathcad14/ 2>/dev/null
        mv -f /mnt$newhome/user/.winemathcad14 /mnt/home/user/.winemathcad14/ 2>/dev/null
        mv -f /mnt$newhome/user/''$'\320\224\320\276\320\272\321\203\320\274\320\265\320\275\321\202\321\213' /mnt/home/user/
        mv -f /mnt$newhome/user/''$'\320\227\320\260\320\263\321\200\321\203\320\267\320\272\320\270' /mnt/home/user/
        mv -f /mnt$newhome/user/''$'\320\236\320\261\321\211\320\265\320\264\320\276\321\201\321\202\321\203\320\277\320\275\321\213\320\265' /mnt/home/user/
        mv -f /mnt$newhome/user/''$'\320\240\320\260\320\261\320\276\321\207\320\270\320\271'' '$'\321\201\321\202\320\276\320\273' /mnt/home/user/
#        ln -s $newhome /mnt/home/user/''$'\320\240\320\260\320\261\320\276\321\207\320\270\320\271'' '$'\321\201\321\202\320\276\320\273'/old_home
      sed -i "s/GRUB_GFXMODE='800x600'/GRUB_GFXMODE='text'/" /mnt/etc/sysconfig/grub2
      sed -i "s/GRUB_TERMINAL_OUTPUT='gfxterm'/GRUB_TERMINAL_OUTPUT='console'/" /mnt/etc/sysconfig/grub2
      sed -i 's/CLASS \-\-class os \\/CLASS \-\-class os \-\-unrestricted \\/' /mnt/etc/grub.d/30_os-prober
###      touch /mnt/etc/bmstu-$(ls /archive/ | grep alt-system | grep -Eo '[0-9].[0-9].[0-9]{1,4}')-p10
      for i in /dev /dev/pts /proc /sys /sys/firmware/efi/efivars /run; do mount -B $i /mnt$i; done
      echo -e "#!/bin/bash\n
              efibootmgr
              os-prober
              grub-install --target=x86_64-efi  --efi-directory=/boot/efi --bootloader-id=altlinux --recheck
              grub-mkconfig -o /boot/grub/grub.cfg
              chown -R 500:500 /home/user
              chown -R 501:502 /home/develop
              chown -R 468:501 /home/usr1cv8
              " > /mnt/tmp/grub.sh
      chmod +x /mnt/tmp/grub.sh
      chroot /mnt /usr/bin/zsh /tmp/grub.sh
      wget -P /patch -A zst -m -p -E -k -K -npd -t 2 -T 5 -e robots=off -R index.html* http://rpl.bmstu.ru/patch/
      for i in $(ls /patch | grep $UPD_VER); do pv /patch/$i | tar -I zstdmt -xp -C /mnt/;done
      umount -l /mnt/boot/efi /mnt/boot /mnt
    else
      rootp=$( (fdisk -l|grep Linux|grep G|grep -v $bootnow|awk '/./{line=$0} END{print line}'|awk '{print $1}'))
      mount $rootp /mnt
        mkdir /home/tmp2
        cp /mnt/etc/sysconfig/grub2 /home/tmp2
        cp -R /mnt/etc/cups/ /home/tmp2
        cp -R /mnt/etc/NetworkManager/system-connections /home/tmp2
        cp /mnt/etc/fstab /home/tmp2
        cp /mnt/etc/hostname /home/tmp2
        cp /mnt/etc/X11/sddm/sddm.conf /home/tmp2
        cp /mnt/etc/rc.d/rc.local /home/tmp2 2>/dev/null
        cp -R /mnt/usr/share/templates/ /home/tmp2
        cp -R /mnt/usr/share/applications/ /home/tmp2
        rm -rf /mnt/etc
        mv /mnt/home /mnt$newhome
      echo "Unpacking /archive/$UPD_ALT"
      pv /archive/$UPD_ALT | tar -I zstdmt --numeric-owner -xp -C /mnt/ --exclude={'proc','dev','sys','mnt','etc/sysconfig/grub2','etc/cups','etc/fstab','etc/hostname','home/user/Документы','home/user/Загрузки','home/user/Общедоступные','home/user/Рабочий стол'}
        cp /home/tmp2/grub2 /mnt/etc/sysconfig/
        /bin/cp -Rf /home/tmp2/cups /mnt/etc/
        /bin/cp -Rf /home/tmp2/system-connections /mnt/etc/NetworkManager/
        cp /home/tmp2/fstab /mnt/etc/
        cp /home/tmp2/hostname /mnt/etc/
        cp /home/tmp2/sddm.conf /mnt/etc/X11/sddm/
        cp /home/tmp2/rc.local /mnt/etc/rc.d/ 2>/dev/null
        /bin/cp -Rf /home/tmp2/templates /mnt/usr/share/
        /bin/cp -Rf /home/tmp2/applications /mnt/usr/share/
        rm -rf /home/tmp2
        echo "Move old soft and home dir"
        rm -rf /mnt/home/user/.PlayOnLinux 2>/dev/null
        mv -f /mnt$newhome/user/.PlayOnLinux /mnt/home/user/ 2>/dev/null
        rm -rf /mnt/home/user/.local 2>/dev/null
        mv -f /mnt$newhome/user/.local /mnt/home/user/ 2>/dev/null
        rm -rf /mnt/home/user/.wine/drive_c/'Program Files'/ASCON 2>/dev/null
        mv -f /mnt$newhome/user/.wine/drive_c/'Program Files'/ASCON /mnt/home/user/.wine/drive_c/'Program Files'/ 2>/dev/null
        rm -rf /mnt/home/user/.winemathcad14/ 2>/dev/null
        mv -f /mnt$newhome/user/.winemathcad14 /mnt/home/user/.winemathcad14/ 2>/dev/null
        mv -f /mnt$newhome/user/''$'\320\224\320\276\320\272\321\203\320\274\320\265\320\275\321\202\321\213' /mnt/home/user/
        mv -f /mnt$newhome/user/''$'\320\227\320\260\320\263\321\200\321\203\320\267\320\272\320\270' /mnt/home/user/
        mv -f /mnt$newhome/user/''$'\320\236\320\261\321\211\320\265\320\264\320\276\321\201\321\202\321\203\320\277\320\275\321\213\320\265' /mnt/home/user/
        mv -f /mnt$newhome/user/''$'\320\240\320\260\320\261\320\276\321\207\320\270\320\271'' '$'\321\201\321\202\320\276\320\273' /mnt/home/user/
#        ln -s $newhome /mnt/home/user/''$'\320\240\320\260\320\261\320\276\321\207\320\270\320\271'' '$'\321\201\321\202\320\276\320\273'/old_home
      sed -i "s/GRUB_GFXMODE='800x600'/GRUB_GFXMODE='text'/" /mnt/etc/sysconfig/grub2
      sed -i "s/GRUB_TERMINAL_OUTPUT='gfxterm'/GRUB_TERMINAL_OUTPUT='console'/" /mnt/etc/sysconfig/grub2
      sed -i 's/CLASS \-\-class os \\/CLASS \-\-class os \-\-unrestricted \\/' /mnt/etc/grub.d/30_os-prober
###      touch /mnt/etc/bmstu-$(ls /archive/ | grep alt-system | grep -Eo '[0-9].[0-9].[0-9]{1,4}')-p10
      echo -e "#!/bin/bash\n
              os-prober
              grub-install ${rootp::-1}
              grub-mkconfig -o /boot/grub/grub.cfg
              chown -R 500:500 /home/user
              chown -R 501:502 /home/develop
              chown -R 468:501 /home/usr1cv8
              " > /mnt/tmp/grub.sh
      chmod +x /mnt/tmp/grub.sh
      for i in /dev /dev/pts /proc /sys /run; do mount -B $i /mnt$i; done
##      mount -t proc /proc /mnt/proc/
##      mount --rbind /sys /mnt/sys/
##      mount --rbind /dev /mnt/dev/
      chroot /mnt /usr/bin/zsh /tmp/grub.sh
      wget -P /patch -A zst -m -p -E -k -K -npd -t 2 -T 5 -e robots=off -R index.html* http://rpl.bmstu.ru/patch/
      for i in $(ls /patch | grep $UPD_VER); do pv /patch/$i | tar -I zstdmt -xp -C /mnt/;done
      umount -l /mnt
    fi
  elif [[ $CHECK_TAR != 0 ]]; then
    echo "/archive/$(ls /archive | grep alt-system) is broken"
    exit 1
  fi
elif [[ "$install" == "no" || "$install" == "n"  ]]; then
  exit 1
fi
