# This script will be executed ON THE HOST when you connect to the host.
# Put here your functions, environment variables, aliases and whatever you need.

build_dir="/opt/"


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

# Source zshrc from the opt directory
if [[ -f "$OPT_DIR/.zshrc" ]]; then
  source "$OPT_DIR/.zshrc"
fi

# Change to the standard home directory
cd "$HOME" 2>/dev/null || true

#sudo run-parts /etc/update-motd.d
