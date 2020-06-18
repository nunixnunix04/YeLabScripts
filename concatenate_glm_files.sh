#PBS -S /bin/bash
#PBS -q batch
#PBS -N concat_TEST_glm
#PBS -l nodes=1:ppn=8
#PBS -l walltime=72:00:00
#PBS -l mem=10gb

#PBS -M username@uga.edu
#PBS -m abe

cd /directory/

head -n1 first_chromosome_file.glm.linear > output_file

for i in {1..22};
do

awk -F ' ' '{if (($7 == "TEST")) print $0}' /ukb_directory/ukb_chr${i}_noNA.$PHENO.glm.linear >> output_file

done