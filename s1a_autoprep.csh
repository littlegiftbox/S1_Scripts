#!/bin/csh -f
# 
# Yuexin Li        Jan  2018
#

if ($#argv < 1) then
    echo ""
    echo "Script to batch pre-process a Sentinel-1a TOPS mode data sets and get the baseline table."
    echo "Usage: s1a_autoprep.csh F1 data.in"
    echo "F1 is the folder of your subswaths"
    echo "data.in is the output file name, if not specify, use default."
    echo ""
    exit 1
endif

if ($#argv == 1) then
    set output=data.in
else
    set output=$2
endif

# Be careful about the rm -rf thing

set Fn=$1

rm -rf $Fn
mkdir $Fn
cd $Fn

rm -rf raw 
mkdir raw
cd raw

rm -f $output   #the filelist for co-registration



# in order to correct for Elevation Antenna Pattern Change, cat the manifest and aux files to the xmls
# delete the first line of the manifest file as it's not a typical xml file.
foreach file (../../raw_orig/*_manifest.safe)

    set YMD=`echo $file | awk '{print substr($1,length($1)-21,8)}'`
    echo $YMD
    awk 'NR>1 {print $0}' < ../../raw_orig/${YMD}_manifest.safe > tmp_file
    cd ../../raw_orig
    set n=`echo $Fn | awk '{print substr($1,2,1)}'`
	set nn = `echo $n | awk '{printf("%d",$0+3)}'`
    set xml=`ls *${YMD}*00[$n,$nn].xml`
    cd ../$Fn/raw
    cat ../../raw_orig/${xml} tmp_file ../../raw_orig/s1a-aux-cal.xml > ./${xml}
		
	# Calculate the date for finding EOF
    set today=`date -j -f %Y%m%d $YMD +%s`
    set ystr=`expr $today - 86400`
    set tmr=`expr $today + 86400`
    set daybefore=`date -r $ystr +%Y%m%d`
    set dayafter=`date -r $tmr +%Y%m%d`


	ln -s ../../raw_orig/*${daybefore}*${dayafter}*.EOF .
	ln -s ../../raw_orig/*${YMD}*00[$n,$nn].tiff .
	
    # At the same time, write input file data.in
    set temp1=`echo $xml | awk -F. '{print $1}'`
    set temp2=`ls *${daybefore}*${dayafter}*.EOF`
    echo "${temp1}:${temp2}" >> $output
end

#somehow for DEM, ln -s doesn't work
cp ../../../topo/dem.grd .
rm tmp_file
# get the baseline_time plot first, select the supermaster and mv it to the first line in data.in, save the baseline_table.dat for sbas use.
preproc_batch_tops.csh data.in dem.grd 1
mv baseline_table.dat ../../.
mv baseline.ps ../../.
# get back to where we used to live
cd ../..