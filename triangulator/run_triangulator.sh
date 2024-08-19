#! /bin/bash

# to run this script, install triangulator from https://github.com/Laakeri/triangulator-msc

for dic in "gridgraphs" "d3graphs"
  do for file in `ls ./graphs/$dic`
    do
      echo $dic $file
      triangulator tw < ./graphs/$dic/$file 
    done
done
    
