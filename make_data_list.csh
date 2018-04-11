#!/bin/csh -f

if ($#argv != 2) then
    echo ""
    echo "Scripts to make data list for make tops frames."
    echo "Usage: make_data_list.csh DATA data.list"
    echo "DATA is where all your .SAFE data lives"
    echo "data.list is the output file for the absolute directory for .SAFE file"
    echo ""
    exit 1
endif

set datadir=$1
set output=$2
set curdir=`pwd`
rm -f $output
foreach filename ($curdir/$datadir/*)
    echo $filename >> $output
end


