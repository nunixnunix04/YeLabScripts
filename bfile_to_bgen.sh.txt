#PBS -S /bin/bash
#PBS -q batch
#PBS -N bfile_to_bgen
#PBS -l nodes=1:ppn=2
#PBS -l walltime=72:00:00
#PBS -l mem=30gb

#PBS -M email@uga.edu
#PBS -m abe

cd /script_folder/

module load PLINK/2.00-alpha2.3-x86_64-20200124

for i in {1..22};
do

# Converts bfile to bgen while QC'ing
plink2 \
--bfile /input_folder/ukb_chr${i} \
--geno 0.02 \
--mind 0.05 \
--maf 0.01 \
--hwe 1e-6 \
--export bgen-1.2 \
--out /output_folder/ukb_chr${i}

done