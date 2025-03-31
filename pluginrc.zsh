# This script will be executed ON THE HOST when you connect to the host.
# Put here your functions, environment variables, aliases and whatever you need.

build_dir=$HOME/.xxh/plugins/xxh-plugin-zsh-robin/build

CURR_DIR="$(cd "$(dirname "$0")" && pwd)"
source $CURR_DIR/.zshrc

# Get the actual home directory (one level up from .xxh)
cd $HOME/..
ACTUAL_HOME=$(pwd)

# Change to the actual home directory
cd $ACTUAL_HOME

# Set HOME environment variable to the actual home (if needed)
export REAL_HOME=$ACTUAL_HOME

#sudo run-parts /etc/update-motd.d
