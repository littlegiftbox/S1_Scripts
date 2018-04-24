#!/bin/csh -f
#
# Script to downsample the large merged InSAR data for poor sbas 
#
# Yuexin Li, April 2018

# We should now lay on the home directory, e.g. S1_data



foreach file(Merge/201*) 
	echo $file
	cd $file
	#multiply the grid increments
	set x_inc = `gmt grdinfo corr.grd -C | awk '{print $8+$8}'`
	set y_inc = `gmt grdinfo corr.grd -C | awk '{print $9+$9}'`
	echo x_inc $x_inc y_inc $y_inc
	gmt grdsample corr.grd -Gcorr_desamp.grd -I${x_inc}/${y_inc}
	gmt grdsample unwrap.grd -Gunwrap_desamp.grd -I${x_inc}/${y_inc}
	cd ../..  
end

