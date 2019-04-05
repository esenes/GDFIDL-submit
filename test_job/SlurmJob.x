#!/bin/bash
#
# usage: sbatch -p batch-long SlurmJob.x
#
#SBATCH --nodes=30
#SBATCH --cpus-per-task=32
#SBATCH --tasks-per-node=1
#SBATCH --time=1-23:0:0
#SBATCH --mail-user=yelong.wei@cern.ch  # <--- Change This
#SBATCH --mail-type=ALL
#
 export GDFIDL_VERSION=180819
 export GDFIDL_HOME=/afs/cern.ch/project/parc/gdfidl/gd1/
 export GDFIDL_LICENSE=$GDFIDL_HOME/gdX-license
 GDFIDL_BINARY=$GDFIDL_HOME/Linux-x86_64/single.mpich-gd1-$GDFIDL_VERSION
#
 echo SLURM_SUBMIT_DIR: $SLURM_SUBMIT_DIR
 echo SLURM_JOB_NODELIST: $SLURM_JOB_NODELIST
 echo SLURM_CPUS_PER_TASK: $SLURM_CPUS_PER_TASK

 RESULTSTO=$SLURM_SUBMIT_DIR/results
 WORKDIR="/tmp/$USER/$SLURM_JOBID/"

# Create the Directories where the Scratch-Files shall be written to:
#
 /usr/local/mpi/mpich/3.2.1/bin/mpirun /usr/bin/mkdir -v -p $WORKDIR
echo "Passed mkdir."

#
# We pass the Value of NROFTHREADS=$SLURM_CPUS_PER_TASK to GdfidL
# We pass the Value of this and that to GdfidL via -Dxxx=yyyy
#

 /usr/local/mpi/mpich/3.2.1/bin/mpirun \
	 $GDFIDL_BINARY \
		-DNROFTHREADS=$SLURM_CPUS_PER_TASK \
		-DLSSUBCWD=$SLURM_SUBMIT_DIR \
		-DRESULTSTO=$RESULTSTO \
		-DSCRATCH=$WORKDIR/scratchfile \
	< $SLURM_SUBMIT_DIR/cell.gdf \
	> $SLURM_SUBMIT_DIR/logfile-$SLURM_JOBID

#End of SlurmJob.x
