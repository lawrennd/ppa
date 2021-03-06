#!/bin/bash
source /usr/local/sungrid/default/common/settings.sh 
# Script to launch many PPA jobs at a PBS managed cluster.

function createMatlabFile
{
#importTool('optimi', 0.12)
#importTool('kern', 0.13)
#importTool('noise', 0.12)
#importTool('ndlutil') 
#importTool('ppa')
#importTool('prior', 0.12)
# create matlab file
cat > $1 <<EOF 
path('/home/nk3/mlprojects/matlab/general',path)
importTool('optimi')
importTool('kern')
importTool('noise')
importTool('ndlutil') 
importTool('ppa')
importTool('prior')
importTool('netlab')
importTool('mltools');
%cd ~/mlprojects/ppa/matlab 
%cd ~/mlprojects/ppa/matlab 
EOF
echo "ppaGunnarResultsTest($2);" >> $1
echo exit >> $1
}	 


function createScriptFile
{
  # create matlab file
    cat > $1 <<EOF 
#!/bin/bash
#
#$ -m a
#$ -M nat@dcs.shef.ac.uk

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

NAME=ppaTestGunnarDataRBF
DIRNAME= #mlprojects/ppa/gunnartest/
RUNNAME=$NAME
DATASETS=banana:breast-cancer:diabetis:german:heart:titanic:twonorm:waveform #:thyroid:ringnorm:flare-solar
IFS=:
echo Creating run scripts ...
INDEX=$((0))
for dataset in $DATASETS
  do
  INDEX=$(($INDEX+1))
  MFILE=$NAME$INDEX.m
  SFILE=$NAME$INDEX.sh
  echo $MFILE
  echo $SFILE
  createMatlabFile "$MFILE" "'${dataset}'" 
  createScriptFile "$SFILE" "$RUNNAME" "$DIRNAME$MFILE"
done
echo Starting jobs ...
INDEX=$((0))
for dataset in $DATASETS
  do
  INDEX=$(($INDEX+1))
  SFILE=$NAME$INDEX.sh
  /usr/local/sge-tools/submitjob NORMAL $NAME$INDEX.log $SFILE 
  sleep 0.1
done
echo Remember to clear the scripts later
