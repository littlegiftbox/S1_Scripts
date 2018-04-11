#!/bin/csh -f
#
#Yuexin Li
#April, 2018

if ($#argv < 2) then
    echo ""
    echo "Scripts to move selected orbits"
    echo "Usage: get_s1a_orbits.csh DATE SAT DIR"
    echo "SAT = S1A, S1B, ..."
    echo "If not specify DIR, use default in Lorax"
    echo ""
    exit 1
endif

if ($#argv == 2) then
    set pool="/Users/yuexinli/InSAR_data/S1_orbit"
else
    set pool=$3
endif

set YMD=$1
set SAT=$2

set today=`date -j -f %Y%m%d $YMD +%s`
set ystr=`expr $today - 86400`
set tmr=`expr $today + 86400`
set daybefore=`date -r $ystr +%Y%m%d`
set dayafter=`date -r $tmr +%Y%m%d`

set target_orb=`ls ${pool}/${SAT}*${daybefore}*${dayafter}*.EOF`
echo start moving $target_orb
cp $target_orb .
