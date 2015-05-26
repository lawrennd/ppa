#!/bin/bash

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
%cd ~/mlprojects/ppa/matlab 
EOF
echo "ppaPlotConvergenceResults($2,$3);" >> $1
echo exit >> $1
}	 


function createScriptFile
{
  # create matlab file
    cat > $1 <<EOF 
#!/bin/bash
#
#PBS -m a
#PBS -M nat@ivy
#PBS -k oe
#PBS -l nodes=1:ppn=1,walltime=52:00:00
#PBS -q low

# Send mail to me if job aborts -m a, -M neil@ivy
# Kill job if it is longer than an hour -l walltime=
EOF
echo "#PBS -N $2" >> $1
echo "" >> $1
echo "echo Running on " >> $1
echo "date" >> $1
echo "echo Using commands  " >> $1
echo "cat $3" >> $1
echo "unset DISPLAY" >> $1
echo "/usr/local/bin/matlab < $3" >> $1
}	 

DIRNAME=mlprojects/ppa/gunnartest/
NAME=ppaGunnarPlotRBF
RUNNAME=$NAME
KERN="{'rbf', 'white', 'bias'}"
DATASETS=banana:breast-cancer:diabetis:heart:titanic:twonorm:waveform #german::thyroid:ringnorm:flare-solar
DATANUM=1 #`seq -s: 1 5`
INVWIDTHPARAMS=0.1 #:1:10
NOISE=\'probit\'
IFS=:
echo Creating run scripts ...
INDEX=$((0))
for dataNum in $DATANUM
  do
  for dataset in $DATASETS
    do
    for invWidth in $INVWIDTHPARAMS
      do
      INDEX=$(($INDEX+1))
      MFILE=$NAME$INDEX.m
      SFILE=$NAME$INDEX.sh
      echo $MFILE
      echo $SFILE
      createMatlabFile "$MFILE" "'${dataset}'" "$dataNum" 
      createScriptFile "$SFILE" "$RUNNAME" "$DIRNAME$MFILE"
    done 
  done
done
echo Starting jobs ...
INDEX=$((0))
for dataNum in $DATANUM
  do
  for dataset in $DATASETS
    do
    for invWidth in $INVWIDTHPARAMS
      do
      INDEX=$(($INDEX+1))
      SFILE=$NAME$INDEX.sh
      qsub $SFILE
      sleep 0.1
    done
  done
done
echo Remember to clear the scripts later
