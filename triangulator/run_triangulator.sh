#! /bin/bash

for dic in "gridgraphs" "d3graphs"
  do for file in `ls ./graphs/$dic`
    do
      echo $dic $file
      # touch ./triangulator/logs/$dic_$file.log
      triangulator tw < ./graphs/$dic/$file 
      # > ./triangulator/logs/$dic_$file.log
    done
done
    
