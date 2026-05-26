#!/usr/bin/env bash

CDIR="$(cd "$(dirname "$0")" && pwd)"
build_dir=$CDIR/build

while getopts A:K:q option
do
  case "${option}"
  in
    q) QUIET=1;;
    A) ARCH=${OPTARG};;
    K) KERNEL=${OPTARG};;
  esac
done

rm -rf $build_dir
mkdir -p $build_dir

for f in pluginrc.zsh
do
    cp $CDIR/$f $build_dir/
done

cd $build_dir

[ $QUIET ] && arg_q='-q' || arg_q=''
[ $QUIET ] && arg_s='-s' || arg_s=''
[ $QUIET ] && arg_progress='' || arg_progress='--show-progress'


cd $build_dir
urls='https://github.com/zsh-users/zsh-autosuggestions.git https://github.com/zsh-users/zsh-syntax-highlighting'

for url in $urls; do
	git clone $arg_q --depth=1 $url
done
# Download antigen
curl -L git.io/antigen > $build_dir/antigen.zsh
# Render canonical shell config from merge_envs via chezmoi.
# Requires chezmoi and a local clone of merge_envs; both are present on every
# merge_envs-bootstrapped machine. We use a temp config to satisfy
# promptStringOnce (which --promptString does NOT feed) and to set modules=ZSH
# (the xxh remote target only needs shell config, no AI/BugBounty/Desktop).
MERGE_ENVS="${MERGE_ENVS_REPO:-${HOME}/git/priv/merge_envs}"
if [[ ! -d "$MERGE_ENVS/home" ]]; then
  echo "[ERR] merge_envs not found at $MERGE_ENVS — set MERGE_ENVS_REPO or clone it" >&2
  exit 1
fi
if ! command -v chezmoi >/dev/null 2>&1 \
   && [[ ! -x "${HOME}/bin/chezmoi" ]]; then
  echo "[ERR] chezmoi not found on PATH or in ~/bin" >&2
  exit 1
fi
chezmoi_bin="$(command -v chezmoi || echo "${HOME}/bin/chezmoi")"

xxh_cm_cfg="$(mktemp -d)/chezmoi.toml"
cat > "$xxh_cm_cfg" <<EOF
[data]
    modules = "ZSH"
    keepassxcDb = ""
    isWSL = false
    isLinux = true
EOF

for f in .zshrc .zsh_alias .p10k.zsh; do
  "$chezmoi_bin" --config "$xxh_cm_cfg" --source "$MERGE_ENVS/home" \
    cat "${HOME}/${f}" > "${build_dir}/${f}" \
    || { echo "[ERR] chezmoi cat failed for $f" >&2; exit 1; }
done
rm -f "$xxh_cm_cfg"


#portable_url='https://,,,/.tar.gz'
#tarname=`basename $portable_url`
#
#cd $build_dir
#
#[ $QUIET ] && arg_q='-q' || arg_q=''
#[ $QUIET ] && arg_s='-s' || arg_s=''
#[ $QUIET ] && arg_progress='' || arg_progress='--show-progress'
#
#if [ -x "$(command -v wget)" ]; then
#  wget $arg_q $arg_progress $portable_url -O $tarname
#elif [ -x "$(command -v curl)" ]; then
#  curl $arg_s -L $portable_url -o $tarname
#else
#  echo Install wget or curl
#fi
#
#tar -xzf $tarname
#rm $tarname
