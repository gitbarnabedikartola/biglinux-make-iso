#!/bin/bash

## create profile biglinux ##
mkdir -p iso-profiles/community/biglinux

cp iso-profiles-biglinux/profile.conf  iso-profiles/community/biglinux/
sed -i '/manjaro2/d'  iso-profiles/community/biglinux/profile.conf

cp iso-profiles-biglinux/pacman-default.conf  iso-profiles/community/biglinux/
cp iso-profiles-biglinux/user-repos.conf  iso-profiles/community/biglinux/

cp -r iso-profiles-biglinux/desktop-overlay/  iso-profiles/community/biglinux/
cp -r iso-profiles-biglinux/live-overlay/  iso-profiles/community/biglinux/

# Remove Mhwd
if [ -e "iso-profiles-biglinux/Mhwd-remove" ]; then
    grep -v -f iso-profiles-biglinux/Mhwd-remove iso-profiles/shared/Packages-Mhwd  > iso-profiles/community/biglinux/Packages-Mhwd
else
    cp -f iso-profiles/shared/Packages-Mhwd iso-profiles/community/biglinux/Packages-Mhwd
fi

# Remove Root
if [ -e "iso-profiles-biglinux/Root-remove" ]; then
    grep -v -f iso-profiles-biglinux/Root-remove iso-profiles/shared/Packages-Root  > iso-profiles/community/biglinux/Packages-Root
else
    cp -f iso-profiles/shared/Packages-Root iso-profiles/community/biglinux/Packages-Root
fi

# Remove Live
if [ -e "iso-profiles-biglinux/Live-remove" ]; then
    grep -v -f iso-profiles-biglinux/Live-remove iso-profiles/shared/Packages-Live  > iso-profiles/community/biglinux/Packages-Live
else
    cp -f iso-profiles/shared/Packages-Live iso-profiles/community/biglinux/Packages-Live
fi

# Remove Desktop
if [ -e "iso-profiles-biglinux/Desktop-remove" ]; then
    grep -v -f iso-profiles-biglinux/Desktop-remove iso-profiles/shared/Packages-Desktop  > iso-profiles/community/biglinux/Packages-Desktop
else
    cp -f iso-profiles/shared/Packages-Desktop iso-profiles/community/biglinux/Packages-Desktop
fi

# Add Mhwd
if [ -e "iso-profiles-biglinux/Mhwd-add" ]; then
    cat iso-profiles-biglinux/Mhwd-add >> iso-profiles/community/biglinux/Packages-Mhwd
fi

# Add Root
if [ -e "iso-profiles-biglinux/Root-add" ]; then
    cat iso-profiles-biglinux/Root-add >> iso-profiles/community/biglinux/Packages-Root
fi

# use mesa-amber ?
if [ "$3" = "amber" ]; then
    echo 'mesa-amber
lib32-mesa-amber' >> iso-profiles/community/biglinux/Packages-Root
fi

# Add Live
if [ -e "iso-profiles-biglinux/Live-add" ]; then
#     echo '' >> iso-profiles/community/biglinux/Packages-Live
    cat iso-profiles-biglinux/Live-add >> iso-profiles/community/biglinux/Packages-Live
fi

# Add Desktop
if [ -e "iso-profiles-biglinux/Desktop-add" ]; then
    cat iso-profiles-biglinux/Desktop-add > iso-profiles/community/biglinux/Packages-Desktop
fi
# Add some things from Packages-Desktop
sed -n '/## Printing/,/^$/p'  iso-profiles/manjaro/kde/Packages-Desktop >>  iso-profiles/community/biglinux/Packages-Desktop
sed -n '/## Xorg Server and Graphics/,/^$/p'  iso-profiles/manjaro/kde/Packages-Desktop >>  iso-profiles/community/biglinux/Packages-Desktop
sed -n '/## Xorg Input Drivers/,/^$/p'  iso-profiles/manjaro/kde/Packages-Desktop >>  iso-profiles/community/biglinux/Packages-Desktop
sed -n '/## Misc/,/^$/p'  iso-profiles/manjaro/kde/Packages-Desktop >>  iso-profiles/community/biglinux/Packages-Desktop

sed -i 's|xf86-input-void||g'  iso-profiles/community/biglinux/Packages-Desktop


# find -type f -exec sed -i '/xdg-su/d' {} +
# find -type f -exec sed -i '/xorg-utils/d' {} +
# find -type f -exec sed -i '/xorg-server-utils/d' {} +

# Remove last }
sed -i ':a;$!{N;ba;};s/\(.*\)}/\1/' /usr/lib/manjaro-tools/util-iso-image.sh

# adicionar ao arquivo

echo '  #BigLinux clean
        path=$1/usr/share/doc
        if [[ -d $path ]]; then
            rm -Rf $path/* &> /dev/null
        fi
        
        #BigLinux clean
        path=$1/usr/share/man
        if [[ -d $path ]]; then
            rm -Rf $path/* &> /dev/null
        fi
        
        #Clean LibreOffice
        path=$1/usr/lib/libreoffice/share/config
        if [[ -d $path ]]; then
        rm -f $path/images_karasa_jaga* &> /dev/null
        rm -f $path/images_elementary* &> /dev/null
        rm -f $path/images_sukapura* &> /dev/null
        rm -f $path/images_colibre_svg.zip &> /dev/null
        rm -f $path/images_sifr_dark_svg.zip &> /dev/null
        rm -f $path/images_sifr_svg.zip &> /dev/null
        rm -f $path/images_breeze_dark_svg.zip &> /dev/null
        rm -f $path/images_breeze_svg.zip &> /dev/null
        fi

        #Clean LibreOffice
        path=$1/usr/share/wallpapers
        if [[ -d $path ]]; then
            rm -Rf $path/Altai
            rm -Rf $path/BytheWater
            rm -Rf $path/Cascade
            rm -Rf $path/ColdRipple
            rm -Rf $path/DarkestHour
            rm -Rf $path/EveningGlow
            rm -Rf $path/Flow
            rm -Rf $path/FlyingKonqui
            rm -Rf $path/IceCold
            rm -Rf $path/Kokkini
            rm -Rf $path/Next
            rm -Rf $path/Opal
            rm -Rf $path/Patak
            rm -Rf $path/SafeLanding
            rm -Rf $path/summer_1am
            rm -Rf $path/Autumn
            rm -Rf $path/Canopee
            rm -Rf $path/Cluster
            rm -Rf $path/ColorfulCups
            rm -Rf $path/Elarun
            rm -Rf $path/FallenLeaf
            rm -Rf $path/Fluent
            rm -Rf $path/Grey
            rm -Rf $path/Kite
            rm -Rf $path/MilkyWay
            rm -Rf $path/OneStandsOut
            rm -Rf $path/PastelHills
            rm -Rf $path/Path
            rm -Rf $path/Shell
            rm -Rf $path/Volna
        fi

         }' | tee -a /usr/lib/manjaro-tools/util-iso-image.sh

# Disable remove pkgs cache
sed -i 's|path=$1/var/lib/pacman/sync|path=$1/usr/share/man|'g /usr/lib/manjaro-tools/util-iso-image.sh

# Change in scripts /usr/share/manjaro-tools
mkdir -p /usr/share/manjaro-tools/iso-profiles/shared/biglinux
cp -Rf iso-profiles/community/biglinux/ /usr/share/manjaro-tools/iso-profiles/shared

#bootsplash
sed -i 's|keyboard keymap|keyboard keymap bootsplash-biglinux|g' /usr/share/manjaro-tools/mkinitcpio.conf

#repo biglinux
cp -f iso-profiles-biglinux/pacman-default.conf /usr/share/manjaro-tools/pacman-default.conf


# buildiso -f -p biglinux -b stable -k linux515

#verificar pacote libreoffice-extension-vero, quem sabe empacotar
 
