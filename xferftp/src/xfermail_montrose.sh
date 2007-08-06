#!/bin/bash
days=`/usr/local/bin/date +%d -d 'yesterday'`

#echo $days

# we create the new data, and then put it on the server.
site_data 919 42 $days |\grep -v ORACLE > temp.out 

echo "Powell Release	acre-ft" >powellrel

#due to the old geezer, we are using 1.9835 here to match Hydromet
cat temp.out | awk '/-200/ {s += $2 ; printf "%s\t%d\n",$1,$2*1.9835} END {printf "Monthly Total is:\t%s\n",s*1.9835}' >>powellrel

mailx -s "Powell Release" crane@wapa.gov,telschow@wapa.gov,tryan@uc.usbr.gov,turnbull@wapa.gov <powellrel

#rm powellrel temp.out

