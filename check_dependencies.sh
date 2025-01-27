#!/usr/bin/env bash
#
# Script to check core dependencies necessary for BIOBASH to run.
# These core dependencies are general for all programs or sometimes for some
# of them. Dependencies required for "interfaced" programs (such as blast or EMBOSS) 
# have to be managed in cases by case basis. 
#

#Source libraries necessary to run check process and other stuff.
#Note that libraries paths here are hardcoded, since we still do not have environmental
#variables set yet.

source lib/bb_utility/check.sh
source lib/shml/shml.sh



echo "
$(fgcolor gray)
  Before running BioBash installation I must check that some software 
  dependencies are met.
  These are basic components that BioBash needs for its functionality. 
  If any of them is missing this installation will be stopped.$(fgcolor end)

  $(fgcolor white)This is a safe procedure $(fgcolor end) $(fgcolor gray)that will not compromise any of your files 
  installed programs or your system integrity. $(fgcolor end)

$(fgcolor gray '...............................................................') $(fgcolor end) 
"
#soft=('zcat' 'wget' 'unzip' 'gzip' 'gnuplot' 'xargs' 'embossversion')
soft=('zcat' 'wget' 'unzip' 'gzip' 'xargs' 'bc' 'java')

#Flow control. Answer should be "y" or "n"
continue=0

until [ $continue  == "y" ] || [ $continue == "n" ]
do

    read -p 'Proceed? [y/n]: ' continue

done

if [[ $continue == "n" ]]; then
    
  echo "
  $(fgcolor yellow)Software dependencies checking stopped. Nothing done.$(fgcolor end)"
    exit 0
    
elif [[ $continue == "y" ]];then

    echo " "
    
else

    echo "$(fgcolor red) ERROR: Installation can not proceed. Unknown reason.$(fgcolor end)"
    exit 1
fi

###########################################################
#              Start actual check
###########################################################
echo "Checking external dependencies ( $(color red)$(icon xmark)$(color end) Not installed. $(color green)$(icon check)$(color end) Installed.)"
#echo "$(hr)"
echo ""

notInstalled=0
for i in "${soft[@]}"; do
  
  check::command_exists "$i"

  # Capture function return value. Can be 0 (found),1 (not found) or 
  # 2 (missing arguments)
  status=$?
 
  #At least one dependency was not found. 
  if [[ $status == 1 ]];then
    notInstalled=1
	echo "$(color red)$(icon xmark)$(color end) $i."
  fi
  
  #Dependency found.
  if [[ $status == 0 ]];then
	echo "$(color green)$(icon check)$(color end) $i."	
  fi
done

#If at least one pre-requisite is not met. Inform user and stop installation.
if [[ $notInstalled == 1 ]];then
	
  echo "
  $(fgcolor red)
  Some software dependencies necessary to install BioBash were not found. $(fgcolor end)
  Please make sure that all programs marked with '$(color red)$(icon xmark)$(color end) ' are correctly installed
  before installing BioBash. 
  	"
	exit 1
else
	echo "$(fgcolor green)
  All BioBASH dependencies were met. Continue installation. $(fgcolor end)

	"

	#This file is a "flag" for main script, so it can continue the installation.
	touch depend_ok

fi
