#!/usr/bin/env bash

if [ -e ./result/csprogs.dat -o -e ./result/menu.dat -o -e ./result/progs.dat -o -e ./result/csprogs.lno -o -e ./result/menu.lno -o -e ./result/progs.lno ]; then
    read -r -p "The operation will compile, delete the current compiled files from result folder to replace and get new compiled ones. Are you sure you want to continue?  [Y/n] " input
    case $input in
    	[yY][eE][sS]|[yY])
    rm -f ./result/*.pk3  #deletes any *.pk3 file (in that case, csprogs-*.pk3)
    ;;
	[nN][oO]|[nN])
    echo "Exiting..."
    exit 0
    ;;
    	*)
    echo "Invalid input, exiting..."
    exit 1
    ;;
    esac
fi

cd ${0%[\\/]*}
set -eu

declare base=xonotic
if [ ! -d "$base" ]; then
    echo "RTFM (README.md)"
    exit 1
fi

: ${PROGS_OUT:=$PWD}
export PROGS_OUT

: ${QCC:=$PWD/gmqcc/gmqcc}
export QCC

export QCCFLAGS_WATERMARK=$(git describe --tags --dirty='~')

relpath() {
    b=; s=$(cd $(readlink -f ${1%%/}); pwd); d=$(cd $2; pwd)
    while [ "${d#$s/}" == "${d}" ]; do s=$(dirname ${s}); b="../${b}"; done
    echo ${b}${d#${s}/}
}

export BUILD_MOD="$(relpath xonotic/qcsrc $PWD)"
export XONOTIC=1
make -C ${base}

mkdir -p result
mv -v ./xonotic/qcsrc/csprogs-*.pk3 result  #alternative file, maybe not necessary
mv -v *.lno result
mv -v *.dat result
