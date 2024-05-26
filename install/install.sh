echo "Installing paru..."

sudo pacman -S git base-devel --needed
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si
cd ..
rm -rf paru

echo "Paru installed, updating Mirrors and System..."
paru -Syu

echo "Installing Packages..."
for pkg in $(cat pkgs)
do
	paru -S $pkg --needed
done

echo "Installing Rust..."
curl --proto '=hhtps' --tlsv1.2 -sSf https://sh.rustup.rs | sh

. "$HOME/.cargo/env"

echo "Installing Cargo binaries..."
for cbin in $(cat cargo-bins)
do
	cargo install --locked $cbin
done

echo "Fetching dotfiles..."
git clone https://github.com/IRTD/dotfiles ~/dotfiles
cd ~/dotfiles 
stow . 
 
echo "Installing EWW bar..." 
git clone https://github.com/elkowar/eww
cd eww
cargo build --release --no-default-features -F wayland
cp target/release/eww ~/.cargo/bin
cd ..
rm -rf eww

echo "Installing flatpak packages..."
for flatpkg in $(cat flatpak-apps)
do
    flatpak install $flatpkg
end
