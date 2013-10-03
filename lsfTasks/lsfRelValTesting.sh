#!/bin/bash

echo "The script starts now."

echo "System: "
uname -a

source /afs/cern.ch/cms/LCG/LCG-2/UI/cms_ui_env.sh
cd /afs/cern.ch/work/a/apsallid/CMS/ServiceWork/DELETETHISFOLDER/CMSSW_6_1_2/src
#cd /afs/cern.ch/work/a/apsallid/CMS/ServiceWork/IanAndMatthewWork/MyTest/CMSSW_6_1_1/src 
eval `scram runtime -sh`
cd -

cp /afs/cern.ch/work/a/apsallid/CMS/ServiceWork/DELETETHISFOLDER/CMSSW_6_1_2/src/Configuration/Generator/python/SingleMuPt100_cfi.py .

cmsDriver.py SingleMuPt100_cfi.py -s GEN,SIM,DIGI,L1,DIGI2RAW,HLT:GRun -n 1000 --eventcontent FEVTDEBUGHLT --conditions auto:mc --mc 
 
rfcp SingleMuPt100_cfi_py_GEN_SIM_DIGI_L1_DIGI2RAW_HLT.root /castor/cern.ch/user/a/apsallid/CMS/ServiceWork/RelValTesting

echo "Step 2"
cmsDriver.py step2 -s RAW2DIGI,RECO,VALIDATION,DQM -n -1 --filein file:SingleMuPt100_cfi_py_GEN_SIM_DIGI_L1_DIGI2RAW_HLT.root --eventcontent FEVTDEBUGHLT --conditions auto:mc --mc
echo "Step 3"
cmsDriver.py step3 -s HARVESTING:validationHarvesting+dqmHarvesting --harvesting AtRunEnd --conditions auto:mc --filein file:step2_RAW2DIGI_RECO_VALIDATION_DQM.root --mc

mv DQM_V0001_R000000001__Global__CMSSW_X_Y_Z__RECO.root RECO_SingleMuPt100_cfi_py_GEN_SIM_DIGI_L1_DIGI2RAW_HLT.root

rfcp RECO_SingleMuPt100_cfi_py_GEN_SIM_DIGI_L1_DIGI2RAW_HLT.root /castor/cern.ch/user/a/apsallid/CMS/ServiceWork/RelValTesting


