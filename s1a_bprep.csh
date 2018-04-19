#!/bin/csh -f
#
#Yuexin Li
#

if ($#argv != 1) then
    echo ""
    echo "Script to prepare the data for raw_orig"
    echo "Usage: s1a_bprep.csh DATA"
    echo "DATA is where all your .SAFE data lives"
    echo ""
    exit 1
endif


rm -rf raw_orig
mkdir raw_orig

#optional
#rm -rf F1 F2 F3
#mkdir F1 F2 F3

set DIR=`pwd`
set datadir=$DIR/$1
cd raw_orig

foreach file ($datadir/*.SAFE)
    echo $file
    set YMD=`echo $file | awk '{print substr($1,length($1)-54,8)}'`
    echo $YMD
    set new_name="${YMD}_manifest.safe"
    cp $file/manifest.safe .
    mv manifest.safe $new_name
    foreach n(1 2 3)
     set nn = `echo $n | awk '{printf("%d",$0+3)}'`
     set subfile=F$n
     set filename1=`ls $file/annotation/*.xml | sed -n ${n}p | awk '{print $1}'`
     set filename2=`echo $filename1 | awk '{print substr($1,1,length($1)-5)}'`
     set filename3=${filename2}${nn}.xml
     #echo $filename3
     if ( -e $filename3 ) then
     cp $file/annotation/*00$nn.xml .
     cp $file/measurement/*00$nn.tiff .
     else
     cp $file/annotation/*00$n.xml .
     cp $file/measurement/*00$n.tiff .
     endif
    end
end

cp $datadir/*.EOF .
cp /Users/yuexinli/InSAR_data/S1_cal/s1a-aux-cal.xml .
echo "Well done! raw_orig is ready for you. "

cd ..
