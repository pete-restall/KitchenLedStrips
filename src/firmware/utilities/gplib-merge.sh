#!/bin/bash
if [ $# -lt 2 ]; then
	echo "Usage: $0 <library.a> <obj1.o|a> [obj2.o|a] ...";
	exit;
fi;

touch $1;
libName=`readlink -e $1`;
utilitiesDir="`dirname $0`";
tempDir="`mktemp -d`";
echo "gplib-merge.sh: using temporary directory ${tempDir}";
cp ${@:2} ${tempDir};
cd $tempDir;
archives=`ls *.a 1>/dev/null 2>&1`;
if [ $? -eq 0 ]; then
	${utilitiesDir}/gplib-extract.sh ${archives};
fi;
gplib -c ${libName} `find ./ -iname "*.o"`;
