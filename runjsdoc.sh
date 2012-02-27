#!/bin/sh

#----------------------------------------------------------------------
# This is a shell for Linux, can be used to generate jsdoc for objectjs
# 
# NOTICE: You should modify JSDOC_ROOT and BROWSER_PATH property before run this shell
#
# @usage :
#    1. sh sh_dir/runjsdoc.sh     (will generate jsdoc)
#    2. sh sh_dir/runjsdoc.sh -o  (will generate jsdoc, and open a html file with specified browser -- not support yet)
#
# @example
#     project
#        |--- src
#        |--- doc
#              |--- jsdoc (auto-generated)
#
#     cd project dir --> sh sh_dir/runjsdoc.sh
#     cd project dir --> sh sh_dir/runjsdoc.sh -o
#
# @version 0.1
# @author wangjeaf
#
# MODIFICATIONS:
#
#----------------------------------------------------------------------

# ---------- set constants, should be modified by user ----------
JSDOC_ROOT="/home/zhifu.wang/dev/jsdoc"
BROWSER_PATH="/usr/lib/firefox-5.0/firefox.sh"

if [ ! -f "$JSDOC_ROOT/jsdoc.js" ];
then
	echo "[ERROR] Wrong jsdoc dir : $JSDOC_ROOT" 
	exit
fi

# ---------- define usage method ----------
usage() {
	echo "[Usage] : "
	echo "   1. sh sh_dir/runjsdoc.sh"
	echo "   2. sh sh_dir/runjsdoc.sh -o (will open html automatically, not support yet)"
}

# ---------- set constants ----------
ROOT_DIR=${PWD}
SRC_DIR="${PWD}/src"
DOC_DIR="${PWD}/doc"
OUT_DIR="${PWD}/doc/jsdoc"
CSS_DIR="${PWD}/doc/jsdoc/styles"
ARG=$1

if [ ! -d $SRC_DIR ];
then
	echo "[ERROR] No src dir in $ROOT_DIR"
	exit
fi
if [ "$ARG" != "-o" -a "$ARG" != "" ]; 
then
	echo "[ERROR] Args error!"
	usage
	exit
fi

# ---------- remove exist files ----------
echo "[INFO] Removing exist doc files in $OUT_DIR"
if [ ! -d $DOC_DIR ];
then 
	mkdir $DOC_DIR
fi
if [ ! -d $OUT_DIR ];
then 
	mkdir $OUT_DIR
fi
cd $OUT_DIR
rm -rf *.html
if [ -d $CSS_DIR ];
then 
	cd $CSS_DIR
	rm -rf *
	rmdir $CSS_DIR
fi

# ---------- generate jsdoc ----------
echo "[INFO] Generating jsdoc for $SRC_DIR"
cd $JSDOC_ROOT
java -cp $JSDOC_ROOT/lib/js.jar org.mozilla.javascript.tools.shell.Main -modules node_modules -modules rhino_modules -modules plugins $JSDOC_ROOT/jsdoc.js $SRC_DIR -r 10 -d $OUT_DIR -p

# ---------- rename a.html#b to a.html, just in case ----------
cd $OUT_DIR
for file in `ls`
do
	char_index=`expr index $file '#'`
	if [ -f $file -a $char_index != 0 ];
	then 
		correct_name=${file%#*}
		if [ -f $correct_name ];
		then 
			rm -f $file
		else
			mv $file $correct_name
		fi
	fi
done

# ---------- open a generated html file with browser specified if in open mode ----------
if [ "$ARG" != "-o" ]; 
then
	exit
fi

if [ ! -f $BROWSER_PATH ];
then
	echo "[ERROR] Wrong browser file path : $BROWSER_PATH"
	exit
fi

for file in `ls *.html`
do
	# echo $file
	# how to start web browser in command line mode?
	exit
done
