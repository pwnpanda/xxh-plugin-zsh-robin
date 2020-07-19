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

opt=$build_dir/opt
mkdir -p $opt
cd $opt
urls='https://github.com/zsh-users/zsh-autosuggestions.git https://github.com/zsh-users/zsh-syntax-highlighting https://github.com/molovo/crash'

for url in $urls; do
	git clone $arg_q --depth=1 $url
done
fpath=$fpath:$build_dir/opt/crash/
curl -L git.io/antigen > $opt/antigen.zsh
curl -L https://gist.githubusercontent.com/pwnpanda/6acc65b062975f8dc3a95aa27318f817/raw/36cbc9a7e089ff3da38f032a241f7cafffb19e0c/.zshrc_remote > $opt/.zshrc_remote
curl -L https://gist.githubusercontent.com/pwnpanda/b68e4a86aba8185d0ad8aca00b3bf8d4/raw/9558dae85b3c32b1b3099da6b3603c2156cca35c/.p10k.zsh > $opt/.p10k.zsh

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
