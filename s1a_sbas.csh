#!/bin/csh -f
#
# Script to create time series
#
# Yuexin Li, Feb 2018
#
# First, prepare the input files needed for sbas
#
rm -f SBAS
mkdir SBAS
cd SBAS
cp ../baseline_table.dat .
rm intf.tab scene.tab
#
# based on baseline_table.dat create the intf.tab and scene.tab for sbas
#
# phase  corherence  ref_id  rep_id  baseline (intf.tab)
foreach dir(../Merge/201*_*)
#echo $dir
    set file1=`echo $dir | awk -F'[/_]' '{print $3}'`
    set file2=`echo $dir | awk -F'[/_]' '{print $4}'`
    set baseline1=`grep "${file1}\." baseline_table.dat |awk '{print $5}'`
    set baseline2=`grep "${file2}\." baseline_table.dat |awk '{print $5}'`
    set baselinedd=`echo "$baseline2 - $baseline1" | bc`
    echo "${dir}/unwrap.grd ${dir}/corr.grd ${file1} ${file2} ${baselinedd}" >> intf.tab
end

# scene_id  day (scene.tab)
set m=`wc -l <intf.tab`
set n=`wc -l <baseline_table.dat`
set i=1
while ($i <= $n)
    set line="`awk '{if (NR == $i) print}' baseline_table.dat`"
    set day=`echo "${line}" | awk '{print $3}'`
    set scene_day=`echo "${line}" | awk '{print $2}'`
    set scene_id=`echo ${scene_day} | awk -F. '{print $1}'`
    echo "${scene_id} ${day}" >> scene.tab
    @ i ++
end


set xdim = `gmt grdinfo -C ../Merge/${file1}_${file2}/unwrap.grd | awk '{print $10}'`
set ydim = `gmt grdinfo -C ../Merge/${file1}_${file2}/unwrap.grd | awk '{print $11}'`
#
# run sbas
#
sbas intf.tab scene.tab $m $n $xdim $ydim -smooth 1.0 -wavelength 0.0554658 -incidence 30 -range 800184.946186 -rms -dem
#
# project the velocity to Geocooridnates
#
#ln -s ../topo/trans.dat .
#proj_ra2ll.csh trans.dat vel.grd vel_ll.grd
#gmt grd2cpt vel_ll.grd -T= -Z -Cjet > vel_ll.cpt
#grd2kml.csh vel_ll vel_ll.cpt
#cd ..