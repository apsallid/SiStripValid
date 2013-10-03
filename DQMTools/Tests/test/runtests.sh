#!/bin/sh

function die { echo $1; status $2; exit $2; }
eval `scram runtime -sh`
python ${LOCAL_TEST_DIR}/whiteRabbit.py -j 4 -n 1,2,11,12 || die 'Failure in running all tests' $?
