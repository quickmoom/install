# _____           _        _ _    _____           _       _   
#|_   _|         | |      | | |  / ____|         (_)     | |  
#  | |  _ __  ___| |_ __ _| | | | (___   ___ _ __ _ _ __ | |_ 
#  | | | '_ \/ __| __/ _` | | |  \___ \ / __| '__| | '_ \| __|
# _| |_| | | \__ \ || (_| | | |  ____) | (__| |  | | |_) | |_ 
#|_____|_| |_|___/\__\__,_|_|_| |_____/ \___|_|  |_| .__/ \__|
#installer for eli arch os                         | |        
#                                                  |_|        
sudo pacman -Syu

# _  _   __   _  _ 
#( \/ ) /__\ ( \/ )
# \  / /(__)\ \  / 
# (__)(__)(__)(__) 

cd 
echo "installing yay"
sudo pacman -S git --noconfirm
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -Si --noconfirm
cd

# ____    __    ___  ____  ___    ____  ____  _____  ___  ____    __    __  __  ___ 
#(  _ \  /__\  / __)(_  _)/ __)  (  _ \(  _ \(  _  )/ __)(  _ \  /__\  (  \/  )/ __)
# ) _ < /(__)\ \__ \ _)(_( (__    )___/ )   / )(_)(( (_-. )   / /(__)\  )    ( \__ \
#(____/(__)(__)(___/(____)\___)  (__)  (_)\_)(_____)\___/(_)\_)(__)(__)(_/\/\_)(___/

echo "installing basic programs"
yay -S brave-browser freedownloadmanager wget --noconfirm 
sudo pacman -S code unzip flatpak --noconfirm

# ____  _____  ____  __    _____  _  _ 
#(  _ \(  _  )(  _ \(  )  (  _  )( \/ )
# )   / )(_)(  ) _ < )(__  )(_)(  )  ( 
#(_)\_)(_____)(____/(____)(_____)(_/\_)   

echo "install roblox? valid options: yes, no."
read roblox_answer
if [ "$roblox_answer" = "yes" ]; then
    flatpak install --user -y --noninteractive https://sober.vinegarhq.org/sober.flatpakref
else
    echo "alrighty then"
fi

# _   _  _  _  ____  ____  __      __    _  _  ____  
#( )_( )( \/ )(  _ \(  _ \(  )    /__\  ( \( )(  _ \ 
# ) _ (  \  /  )___/ )   / )(__  /(__)\  )  (  )(_) )
#(_) (_) (__) (__)  (_)\_)(____)(__)(__) (_)\_)(____/ 

#Optional installs for hyprland window manager only
echo "install hyprland rice? valid options: yes, no."
read hyprland_answer
if [ "$hyprland_answer" = "yes" ]; then
    #programs
    sudo pacman -S alacritty  --noconfirm
    yay -S pywal --noconfirm

    #eww
    cd .config
    sudo pacman -S rustup --noconfirm --needed --overwrite "*"
    sudo pacman -S cargo gtk3 gtk-layer-shell pango gdk-pixbuf2 libdbusmenu-gtk3 cairo glib2 gcc-libs glibc --noconfirm
    git clone https://github.com/elkowar/eww.git
    cd eww
    cargo build --release --no-default-features --features=wayland
    cd 
else 
    echo "alrighty then"
fi 

# ____  _   _  _____  ____  _____    ____  ____  ____  ____  _____  ____  ___ 
#(  _ \( )_( )(  _  )(_  _)(  _  )  ( ___)(  _ \(_  _)(_  _)(  _  )(  _ \/ __)
# )___/ ) _ (  )(_)(   )(   )(_)(    )__)  )(_) )_)(_   )(   )(_)(  )   /\__ \
#(__)  (_) (_)(_____) (__) (_____)  (____)(____/(____) (__) (_____)(_)\_)(___/

echo "install photo editors? valid options: gimp, krita, no, both."
read photo_editor_answer
if [ "$photo_editor_answer" = "gimp" ]; then
    sudo pacman -S gimp --noconfirm
elif [ "$photo_editor_answer" = "krita" ]; then
    sudo pacman -S krita --noconfirm
elif [ "$photo_editor_answer" = "both" ]; then
    sudo pacman -S gimp krita --noconfirm
elif [ "$photo_editor_answer" = "no" ]; then
    echo "alrighty then"
fi

# _  _  _  _  ____  ____  ____    __   
#( \( )( \/ )(_  _)(  _ \(_  _)  /__\  
# )  (  \  /  _)(_  )(_) )_)(_  /(__)\ 
#(_)\_)  \/  (____)(____/(____)(__)(__)
echo "install Nvidia drivers? valid options: yes, no."
read nvidia_answer
if [ "$nvidia_answer" = "yes" ]; then
    sudo pacman -S nvidia nvidia-utils nvidia-dkms --noconfirm
else 
    echo "alrighty then"
fi

# ___  __  __  ____  ____  __    ___  ____    __    ____  _  _  __  __  _  _ 
#/ __)(  )(  )(  _ \( ___)/__\  / __)( ___)  (  )  (_  _)( \( )(  )(  )( \/ )
#\__ \ )(__)(  )   / )__)/(__)\( (__  )__)    )(__  _)(_  )  (  )(__)(  )  ( 
#(___/(______)(_)\_)(__)(__)(__)\___)(____)  (____)(____)(_)\_)(______)(_/\_)
echo "install surface drivers? valid options: yes, no."
read surface_answer
if [ "$surface_answer" = "yes" ]; then
    curl -s https://raw.githubusercontent.com/linux-surface/linux-surface/master/pkg/keys/surface.asc \
    | sudo pacman-key --add -
    sudo pacman-key --lsign-key 56C464BAAC421453
    echo -e "\n[linux-surface]\nServer = https://pkg.surfacelinux.com/arch/" | sudo tee -a /etc/pacman.conf > /dev/null
    sudo pacman -S linux-surface linux-surface-headers iptsd linux-firmware-marvell --noconfirm                                                                  
    sudo pacman -S linux-surface-secureboot-mok --noconfirm                                                                    
    sudo grub-mkconfig -o /boot/grub/grub.cfg                                                                           
else
    echo "alrighty then"
fi

# ____  __  __  __  __  __      __   ____  _____  ____  ___ 
#( ___)(  \/  )(  )(  )(  )    /__\ (_  _)(  _  )(  _ \/ __)
# )__)  )    (  )(__)(  )(__  /(__)\  )(   )(_)(  )   /\__ \
#(____)(_/\/\_)(______)(____)(__)(__)(__) (_____)(_)\_)(___/

echo "Install emulators? Valid options: yes, lightweight, no."
read emulator_answer
echo "Install EmulationStation? Valid options: yes, no."
read emulationstation_answer
if [ "$emulator_answer" = "yes" ]; then
    flatpak install flathub net.rpcs3.RPCS3
    flatpak install flathub org.ryujinx.Ryujinx
    flatpak install flathub io.github.lime3ds.Lime3DS
    flatpak install flathub org.DolphinEmu.dolphin-emu
    flatpak install flathub info.cemu.Cemu
elif [ "$emulator_answer" = "lightweight" ]; then
    flatpak install flathub io.github.lime3ds.Lime3DS
    flatpak install flathub org.DolphinEmu.dolphin-emu
elif [ "$emulator_answer" = "no" ]; then
    echo "Alrighty then."
fi
if [ "$emulator_answer" = "yes" ] || [ "$emulator_answer" = "lightweight" ]; then
    echo "Install path"
    mkdir .emulation
fi
if [ "$emulationstation_answer" = "yes" ]; then
    cd .emulation
    curl https://gitlab.com/es-de/emulationstation-de/-/package_files/132901118/download --output ES-DEx64.AppImage
    chmod +x ES-DEx64.AppImage
fi

# ____  __      __    ___  _  _    __    ____   ___  _   _ 
#(  _ \(  )    /__\  / __)( )/ )  /__\  (  _ \ / __)( )_( )
# ) _ < )(__  /(__)\( (__  )  (  /(__)\  )   /( (__  ) _ ( 
#(____/(____)(__)(__)\___)(_)\_)(__)(__)(_)\_) \___)(_) (_)

echo "install blackarch tools? valid options: yes, minimal, no."
read blackarch_answer
if [ "$blackarch_answer" = "yes" ]; then
    # Add more code here if needed for full BlackArch installation
    echo "BlackArch tools installation process."
elif [ "$blackarch_answer" = "minimal" ]; then
    # Add more code here if needed for minimal BlackArch installation
    echo "Minimal BlackArch tools installation process."
else
    echo "alrighty then"
fi
