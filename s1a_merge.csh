#!/bin/csh -f
#
# Script to merge subswaths
#
# Yuexin Li, Feb 2018
#

#rm -f Merge
#mkdir Merge
cd Merge
rm subswaths.in
# cp ../batch_tops.config .
# cp ../topo/dem.grd .

# Write input file subswaths.in
# Need to correct for path (actually it would be good to be independent of path)
foreach dirF1(../F1/intf_all/*)
    echo $dirF1
    set file=`echo $dirF1 | awk -F/ '{print $4}'`
    set dirF2="../F2/intf_all/${file}"
    set dirF3="../F3/intf_all/${file}"

    cd $dirF1
    set intf=`ls *.PRM`
    set intf1_F1=`echo $intf| awk '{print $1}'`
    set intf2_F1=`echo $intf| awk '{print $2}'`
    cd ../../../Merge

    cd $dirF2
    set intf=`ls *.PRM`
    set intf1_F2=`echo $intf| awk '{print $1}'`
    set intf2_F2=`echo $intf| awk '{print $2}'`
    cd ../../../Merge

    cd $dirF3
    set intf=`ls *.PRM`
    set intf1_F3=`echo $intf| awk '{print $1}'`
    set intf2_F3=`echo $intf| awk '{print $2}'`
    cd ../../../Merge

    echo "${dirF1}/:${intf1_F1}:${intf2_F1},${dirF2}/:${intf1_F2}:${intf2_F2},${dirF3}/:${intf1_F3}:${intf2_F3}" >> subswaths.in

end



# Merge, unwrap and geocode the interferograms
merge_batch.csh subswaths.in batch_tops.config
echo "Done merging!"
cd ..
