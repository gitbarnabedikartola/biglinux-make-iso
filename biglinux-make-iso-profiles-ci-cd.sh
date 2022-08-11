#!/bin/bash

workdir=$PWD
isoprofilesdir=iso-profiles
makeisoprofilesdir=$PWD
## depends ##

#https://gitlab.manjaro.org/profiles-and-settings/iso-profiles.git
# clone or Update git
if [ ! -d "$workdir/$isoprofilesdir" ]
then
    git clone https://gitlab.manjaro.org/profiles-and-settings/iso-profiles.git
else
    cd $workdir/$isoprofilesdi
    git pull
    cd $workdir
fi

#remove old profile
if [ -d "$workdir/$isoprofilesdir/community/biglinux" ]; then
    rm -r $workdir/$isoprofilesdir/community/biglinux
fi

## create profile biglinux ##
mkdir -p $workdir/$isoprofilesdir/community/biglinux

#files
cp $workdir/$makeisoprofilesdir/profile.conf  $workdir/$isoprofilesdir/community/biglinux/
cp $workdir/$makeisoprofilesdir/pacman-default.conf  $workdir/$isoprofilesdir/community/biglinux/
cp $workdir/$makeisoprofilesdir/user-repos.conf  $workdir/$isoprofilesdir/community/biglinux/
#dirs
cp -r $workdir/$makeisoprofilesdir/desktop-overlay/  $workdir/$isoprofilesdir/community/biglinux/
cp -r $workdir/$makeisoprofilesdir/live-overlay/  $workdir/$isoprofilesdir/community/biglinux/

# Remove Mhwd
if [ -e "$workdir/$makeisoprofilesdir/Mhwd-remove" ]; then
    grep -v -f $workdir/$makeisoprofilesdir/Mhwd-remove  $workdir/$isoprofilesdir/shared/Packages-Mhwd  >  $workdir/$isoprofilesdir/community/biglinux/Packages-Mhwd
else
    echo "ERROR"
    exit 1
fi

# Remove Root
if [ -e "$workdir/$makeisoprofilesdir/Root-remove" ]; then
    grep -v -f $workdir/$makeisoprofilesdir/Root-remove  $workdir/$isoprofilesdir/shared/Packages-Root  >  $workdir/$isoprofilesdir/community/biglinux/Packages-Root
else
    echo "ERROR"
    exit 1
fi

# Remove Live
if [ -e "$workdir/$makeisoprofilesdir/Live-remove" ]; then
    grep -v -f $workdir/$makeisoprofilesdir/Live-remove  $workdir/$isoprofilesdir/shared/Packages-Live  >  $workdir/$isoprofilesdir/community/biglinux/Packages-Live
else
    echo "ERROR"
    exit 1
fi

# Remove Desktop
if [ -e "$workdir/$makeisoprofilesdir/Desktop-remove" ]; then
    grep -v -f $workdir/$makeisoprofilesdir/Desktop-remove  $workdir/$isoprofilesdir/shared/Packages-Desktop  >  $workdir/$isoprofilesdir/community/biglinux/Packages-Desktop
else
    echo "ERROR"
    exit 1
fi

# Add Mhwd
if [ -e "$workdir/$makeisoprofilesdir/Mhwd-add" ]; then
    cat $workdir/$makeisoprofilesdir/Mhwd-add  >>  $workdir/$isoprofilesdir/community/biglinux/Packages-Mhwd
else
    echo "ERROR"
    exit 1
fi


# Add Root
if [ -e "$workdir/$makeisoprofilesdir/Root-add" ]; then
    cat $workdir/$makeisoprofilesdir/Root-add  >>  $workdir/$isoprofilesdir/community/biglinux/Packages-Root
else
    echo "ERROR"
    exit 1
fi

# # use mesa-amber ?
# if [ "$3" = "amber" ]; then
#     echo 'mesa-amber
# lib32-mesa-amber' >> $isoprofilesdir/community/biglinux/Packages-Root
# fi

# Add Live
if [ -e "$workdir/$makeisoprofilesdir/Live-add" ]; then
#     echo '' >> $isoprofilesdir/community/biglinux/Packages-Live
    cat $workdir/$makeisoprofilesdir/Live-add  >>  $workdir/$isoprofilesdir/community/biglinux/Packages-Live
else
    echo "ERROR"
    exit 1
fi

# Add Desktop
if [ -e "$workdir/$makeisoprofilesdir/Desktop-add" ]; then
    cat  $workdir/$makeisoprofilesdir/Desktop-add  >  $workdir/$isoprofilesdir/community/biglinux/Packages-Desktop
else
    echo "ERROR"
    exit 1
fi

# Add some things from Packages-Desktop
sed -n '/## Printing/,/^$/p'  $workdir/$isoprofilesdir/manjaro/kde/Packages-Desktop  >>  $workdir/$isoprofilesdir/community/biglinux/Packages-Desktop
sed -n '/## Xorg Server and Graphics/,/^$/p'  $workdir/$isoprofilesdir/manjaro/kde/Packages-Desktop  >>  $workdir/$isoprofilesdir/community/biglinux/Packages-Desktop
sed -n '/## Xorg Input Drivers/,/^$/p'  $workdir/$isoprofilesdir/manjaro/kde/Packages-Desktop  >>  $workdir/$isoprofilesdir/community/biglinux/Packages-Desktop
sed -n '/## Misc/,/^$/p'  $workdir/$isoprofilesdir/manjaro/kde/Packages-Desktop  >>  $workdir/$isoprofilesdir/community/biglinux/Packages-Desktop
sed -i 's|xf86-input-void||g'  $workdir/$isoprofilesdir/community/biglinux/Packages-Desktop

