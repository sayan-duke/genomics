#!/bin/tcsh
#
#$ -S /bin/tcsh -cwd
#$ -o enrich.out -j y
#$ -t 1:total_number_of_samples
cd /directory path

octave-2.1.72 octaveEnrich.m $SGE_TASK_ID

