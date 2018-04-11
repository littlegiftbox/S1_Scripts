#!/bin/csh -f 
#        $Id$
#
#   Xiaohua(Eric) Xu Mar 2017
# 
#   Script to shift time in azimuth by a number of lines
# 


 if ($#argv < 2) then
   echo " "
   echo "Usage: shift_aline_PRM.csh file.PRM num_lines "
   echo " " 
   echo "Example: shift_aline_PRM.csh IMG-HH-ALPSRP.....PRM 12354.675"
   echo " "
   echo "Note: To shift the PRM file with a given number of lines along azimuth."
   exit 1
 endif

 set nl = $2
 set file = $1
 set prf = `grep PRF $file | awk '{print $3}'`
 set ttmp = `grep clock_start $file | grep -v SC_clock_start | awk '{print $3}' | awk '{printf ("%.12f",$1 + '$nl'/'$prf'/86400.0)}'`
 update_PRM.csh $file clock_start $ttmp
 set ttmp = `grep clock_stop $file | grep -v SC_clock_stop | awk '{print $3}' | awk '{printf ("%.12f",$1 + '$nl'/'$prf'/86400.0)}'`
 update_PRM.csh $file clock_stop $ttmp
 set ttmp = `grep SC_clock_start $file | awk '{print $3}' | awk '{printf ("%.12f",$1 + '$nl'/'$prf'/86400.0)}'`
 update_PRM.csh $file SC_clock_start $ttmp
 set ttmpt = `grep SC_clock_stop $file | awk '{print $3}' | awk '{printf ("%.12f",$1 + '$nl'/'$prf'/86400.0)}'`
 update_PRM.csh $file SC_clock_stop $ttmp
