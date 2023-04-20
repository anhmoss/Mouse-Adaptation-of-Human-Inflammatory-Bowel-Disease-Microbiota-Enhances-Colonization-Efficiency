#!/bin/bash

#SBATCH --partition=Orion
#SBATCH --time=00:30:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=16
#SBATCH --mem=10GB

module load qiime2/2021.2

qiime tools export \
  --input-path  /nobackup/afodor_research/datasets/Balfour_2022/220824_UNC23_0386_000000000-KJC2N-q2-silva/220824_UNC23_0386_000000000-KJC2N-q2-silva/QZA/base/table-l6.qza \
  --output-path  /nobackup/afodor_research/aduong/Balfour_2022_files/table-L6

biom convert -i /nobackup/afodor_research/aduong/Balfour_2022_files/table-L6/feature-table.biom -o /nobackup/afodor_research/aduong/Balfour_2022_files/table-L6/feature-table.txt --to-tsv