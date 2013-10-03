#!/bin/bash

mkdir jobs

for i in `seq 1 100`;
do
echo $i

cp lsfRelValTesting_multiplefiles.sh lsfRelValTesting_multiplefiles_$i.sh 

mv lsfRelValTesting_multiplefiles_$i.sh jobs/

cd jobs

chmod 777 lsfRelValTesting_multiplefiles_$i.sh
bsub -q 2nd -o out$i lsfRelValTesting_multiplefiles_$i.sh $i

cd -

done    

 
