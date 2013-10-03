#!/bin/bash

function die { echo Failure $1: status $2 ; exit $2 ; }

export LOCAL_TEST_DIR=$PWD
echo ${LOCAL_TEST_DIR}

for bookIn in CTOR BJ BR

do
  #OLD file1
  testConfig=create_file1_oldf_cfg.py
  rm -f dqm_file1_oldf.root
  echo ${testConfig} ------------------------------------------------------------
  cmsRun ${LOCAL_TEST_DIR}/${testConfig} $bookIn || die "cmsRun ${testConfig}" $?

  #OLD file3
  testConfig=create_file3_oldf_cfg.py
  rm -f dqm_file3_oldf.root
  echo ${testConfig} ------------------------------------------------------------
  cmsRun ${LOCAL_TEST_DIR}/${testConfig} $bookIn || die "cmsRun ${testConfig}" $?

  #check file1
  testConfig=check_file1_oldf_cfg.py 
  echo ${testConfig} ------------------------------------------------------------
  cmsRun ${LOCAL_TEST_DIR}/${testConfig} || die "cmsRun ${testConfig}" $?

  #check file3
  testConfig=check_file3_oldf_cfg.py
  echo ${testConfig} ------------------------------------------------------------
  cmsRun ${LOCAL_TEST_DIR}/${testConfig} || die "cmsRun ${testConfig}" $?

  #MERGE file1file3
  testConfig=merge_file1_file3_oldf_cfg.py
  rm -f dqm_merged_file1_file3_oldf.root
  echo ${testConfig} ------------------------------------------------------------
  cmsRun ${LOCAL_TEST_DIR}/${testConfig} || die "cmsRun ${testConfig}" $?

  #CHECK MERGED
  testConfig=check_merged_file1_file3_oldf_cfg.py
  echo ${testConfig} ------------------------------------------------------------
  cmsRun ${LOCAL_TEST_DIR}/${testConfig} || die "cmsRun ${testConfig}" $?

  #HARVEST MERGED FILE
  testConfig=harv_merged_file1_file3_oldf_cfg.py
  rm -f DQM_V0001_R00000000?__Test__Merged_File1_File3_oldf__DQM.root
  echo ${testConfig} ------------------------------------------------------------
  cmsRun ${LOCAL_TEST_DIR}/${testConfig} || die "cmsRun ${testConfig}" $?

  #HARVEST SINGLE FILES 
  testConfig=harv_file1_file3_oldf_cfg.py
  rm -f DQM_V0001_R00000000?__Test__File1_File3_oldf__DQM.root
  echo ${testConfig} ------------------------------------------------------------
  cmsRun ${LOCAL_TEST_DIR}/${testConfig} || die "cmsRun ${testConfig}" $?

  #CHECK HARVESTED FILE
  echo COMPARING: single vs merged ------------------------------------------------------------
  compare_using_files.py DQM_V0001_R000000001__Test__{,Merged_}File1_File3_oldf__DQM.root -C -s b2b -t 0.999999 
  compare_using_files.py DQM_V0001_R000000002__Test__{,Merged_}File1_File3_oldf__DQM.root -C -s b2b -t 0.999999 


done

exit 0
