# This script will be executed ON THE HOST when you connect to the host.
# Put here your functions, environment variables, aliases and whatever you need.

# Define where files are located in the xxh structure
XXH_PLUGIN_PATH="$HOME/.xxh/plugins/xxh-plugin-zsh-robin/build"

# Set OPT_DIR explicitly to where we want to source files from
export OPT_DIR="/opt"

# If we're in a .xxh environment, correct the HOME path
if [[ "$HOME" == *".xxh"* ]]; then
  # Extract username from path
  if [[ "$HOME" == "/root"* ]]; then
    REAL_HOME="/root"
  else
    USERNAME=$(echo "$HOME" | sed -E 's|^/([^/]+)/\.xxh.*$|\1|')
    REAL_HOME="/home/$USERNAME"
    [[ "$USERNAME" == "root" ]] && REAL_HOME="/root"
  fi

  # Set HOME to the standard home directory
  export HOME="$REAL_HOME"
fi

ZA_PATH="$OPT_DIR/zsh-autosuggestions"
ZSH_PATH="$OPT_DIR/zsh-syntax-highlighting"
ANTIGEN_PATH="$OPT_DIR/antigen"

# Create symbolic links from our xxh plugin directory to /opt if they don't exist
# This requires sudo privileges - you may need to adjust based on your permissions
if [[ ! -d "$OPT_DIR/zsh-autosuggestions" ]]; then
  # Create the directory if it doesn't exist (with sudo if needed)
  if [[ ! -d "$OPT_DIR" ]]; then
    sudo mkdir -p "$ZA_PATH"
    sudo mkdir -p "$ZSH_PATH"
    sudo mkdir -p "$ANTIGEN_PATH"
  fi
  

  # Create symbolic links to the plugin files
  sudo ln -sf "$XXH_PLUGIN_PATH/zsh-autosuggestions" "$ZA_PATH"
  sudo ln -sf "$XXH_PLUGIN_PATH/zsh-syntax-highlighting" "$ZSH_PATH"
  sudo ln -sf "$XXH_PLUGIN_PATH/antigen.zsh" "$ANTIGEN_PATH/antigen.zsh"
  
  # Link dotfiles to /opt
  for file in "$XXH_PLUGIN_PATH"/.zshrc "$XXH_PLUGIN_PATH"/.p10k.zsh "$XXH_PLUGIN_PATH"/.zsh_alias; do
    if [[ -f "$file" ]]; then
      sudo ln -sf "$file" "$HOME/$(basename "$file")"
    fi
  done
fi

# Source zshrc from the opt directory
if [[ -f "~/.zshrc" ]]; then
  source "~/.zshrc"
fi

# Change to the standard home directory
cd "$HOME" 2>/dev/null || true

#sudo run-parts /etc/update-motd.d
