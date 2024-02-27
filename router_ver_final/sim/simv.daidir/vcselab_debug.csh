#!/bin/csh -f

cd /home1/BRN34/SuryaJB/VLSI_RN/UVM_LABS/router_ver_final/sim

#This ENV is used to avoid overriding current script in next vcselab run 
setenv SNPS_VCSELAB_SCRIPT_NO_OVERRIDE  1

/home/cad/eda/SYNOPSYS/VCS/vcs/T-2022.06-SP1/linux64/bin/vcselab $* \
    -o \
    simv \
    -nobanner \

cd -

