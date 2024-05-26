clear
echo "Installing Rust..."
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

. "$HOME/.cargo/env"
rustup default stable

clear
echo "Installing paru..."

sudo pacman -S git base-devel --needed
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si
cd ..
rm -rf paru

clear
echo "Paru installed, updating Mirrors and System..."
paru -Syu

clear
echo "Installing Packages..."
for pkg in $(cat pkgs)
do
	paru -S $pkg --needed
done


clear
echo "Installing Cargo binaries..."
for cbin in $(cat cargo-bins)
do
	cargo install --locked $cbin
done

clear
echo "Fetching dotfiles..."
git clone https://github.com/IRTD/dotfiles ~/dotfiles
cd ~/dotfiles 
git switch origin hypr-new
git pull origin hypr-new
stow . 

clear
echo "Installing EWW bar..." 
git clone https://github.com/elkowar/eww
cd eww
cargo build --release --no-default-features -F wayland
cp target/release/eww ~/.cargo/bin
cd ..
rm -rf eww

clear
echo "Installing flatpak packages..."
for flatpkg in $(cat flatpak-apps)
do
    flatpak install $flatpkg
done

clear
echo "Setting zsh as default shell"
chsh -s /bin/zsh

clear
echo "Fetching nvim config..."
git clone https://github.com/IRTD/nvim ~/.config/nvim

clear
echo "Everything done, rebooting..."
reboot
