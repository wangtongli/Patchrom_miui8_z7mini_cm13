#!/bin/bash
#
#sh for miui patchrom
BUILD_NUMBER=6`date +.%-m.%-d`
CLEAN=$1
LAST_TARGET_ZIP=$2
clear
echo "Will make fullota , if you want to make ota package, please input ./auto_make.sh LAST_TARGET_ZIP(to make ota package) "
sleep 2s
. build.sh
START_TIME=`date +%s`
if [ -z "$CLEAN" ]
then
make clean
fi
make fullota BUILD_NUMBER=$BUILD_NUMBER
mv out/fullota.zip out/fullota-$BUILD_NUMBER.zip
if [ -n "$2" ]
then
../tools/releasetools/ota_from_target_files -k ../build/security/testkey -i $LAST_TARGET_ZIP out/target_files.zip OTA-$LAST_TARGET_ZIP-$BUILD_NUMBER.zip
mv out/target_files.zip $BUILD_NUMBER-target.zip
fi
END_TIME=`date +%s`
let "ELAPSED_TIME=$END_TIME-$START_TIME"
let "ELAPSED_TIME_MIN=$ELAPSED_TIME/60"
let "ELAPSED_TIME_SEC=$ELAPSED_TIME-$ELAPSED_TIME_MIN*60"
echo "====编译用时== $ELAPSED_TIME_MIN 分 $ELAPSED_TIME_SEC 秒"
#clean something and save out sources
#rm -rf out/*-tozip
#rm -rf out/*.apk
#rm -rf out/*.zip
#rm -rf out/*.jar
#rm -rf out/target_files
#mv out out-$BUILD_NUMBER
#clean stockrom.zip and something
#make clean

