#!/bin/bash
if [ $# -lt 4 ]; then
cat <<EOF
./global sroot tgdir option string
EOF
echo "缺少参数，程序退出。01"
exit
fi

export GTAGSROOT=$1
export GTAGSDBPATH=$2
export GTAGSLIBPATH=$2

global $3 $4
