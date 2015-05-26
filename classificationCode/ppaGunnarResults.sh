#!/bin/bash
source /usr/local/sungrid/default/common/settings.sh 
# Script to launch many PPA jobs at a PBS managed cluster.

function createMatlabFile
{
  # create matlab file
    cat > $1 <<EOF 
    path('/home/nk3/mlprojects/matlab/general',path)
importTool('optimi', 0.12)
importTool('kern', 0.13)
importTool('noise', 0.12)
importTool('ndlutil') 
importTool('ppa')
importTool('mltools')
importTool('prior', 0.12)
%cd ~/mlprojects/ppa/matlab 
EOF
echo "ppaGunnarResults;" >> $1
echo exit >> $1
}	 


function createScriptFile
{
  # create matlab file
    cat > $1 <<EOF 
#!/bin/bash
#
#$ -m a
#$ -M neil@ivy

# Send mail to me if job aborts -m a, -M neil@ivy
# Kill job if it is longer than an hour -l walltime=
EOF
echo "#$ -N $2" >> $1
echo "" >> $1
echo "echo Running on " >> $1
echo "date" >> $1
echo "echo Using commands  " >> $1
echo "cat $3" >> $1
echo "unset DISPLAY" >> $1
echo "/usr/local/bin/matlab < $3" >> $1
}	 

NAME=ppaGunnarResultsRun
DIRNAME= #mlprojects/ppa/gunnartest/
RUNNAME=$NAME
IFS=:
echo Creating run scripts ...
MFILE=$NAME.m
SFILE=$NAME.sh
echo $MFILE
echo $SFILE
createMatlabFile "$MFILE" 
createScriptFile "$SFILE" "$RUNNAME" "$DIRNAME$MFILE"
echo Starting jobs ...
SFILE=$NAME.sh
/usr/local/sge-tools/submitjob NORMAL $NAME$INDEX.log $SFILE 
sleep 0.1
echo Remember to clear the scripts later
