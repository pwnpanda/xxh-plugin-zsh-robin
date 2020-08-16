# This script will be executed ON THE HOST when you connect to the host.
# Put here your functions, environment variables, aliases and whatever you need.

build_dir=$HOME/.xxh/plugins/xxh-plugin-zsh-robin/build

CURR_DIR="$(cd "$(dirname "$0")" && pwd)"
source $CURR_DIR/.zshrc

#sudo run-parts /etc/update-motd.d
