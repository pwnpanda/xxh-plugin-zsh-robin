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
# Clone your dotfiles
git clone https://github.com/pwnpanda/dotfiles.git $build_dir/dotfiles
# Move dotfiles to build directory
for file in $build_dir/dotfiles/.*; do
    # Ignore . and .. directories
    if [[ "$(basename "$file")" != "." && "$(basename "$file")" != ".." && "$(basename "$file")" != ".git" ]]; then
        cp -a "$file" "$build_dir/"
    fi
done
rm -rf dotfiles


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
