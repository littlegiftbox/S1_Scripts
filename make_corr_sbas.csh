#!/bin/csh -f
#
# Script to calculate mean coherence for each interferogram. 
#
# Yuexin Li, April 2018

# We should now lay on the home directory, e.g. S1_data

rm coherence.dat

foreach file(Merge/201*) 
	echo $file
	cd $file
	set filename=`echo $file | awk -F/ '{print $2}'`
	set i_mean = `gmt grdinfo -L2 corr.grd -C | awk '{print $12}'`
	set i_stdev = `gmt grdinfo -L2 corr.grd -C | awk '{print $13}'`
	echo $filename $i_mean $i_stdev >> ../../coherence.dat
	rm coherence.dat
	cd ../..  
end


# Make file for plotting a coherence map 
# But coherence based SBAS should be a pixel by pixel match
