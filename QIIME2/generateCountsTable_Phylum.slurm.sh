#!/bin/bash

#SBATCH --partition=Orion
#SBATCH --time=08:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=16
#SBATCH --mem=80GB

module load qiime2/2021.2

qiime taxa collapse \
      --i-table /scratch/aduong/Balfour2022/220824_UNC23_0386_000000000-KJC2N-q2-silva/220824_UNC23_0386_000000000-KJC2N-q2-silva/QZA/base/table.qza \
      --i-taxonomy /scratch/aduong/Balfour2022/220824_UNC23_0386_000000000-KJC2N-q2-silva/220824_UNC23_0386_000000000-KJC2N-q2-silva/QZA/taxa/taxonomy.qza \
      --p-level 2 \
      --o-collapsed-table /scratch/aduong/Balfour2022/table-L2.qza

qiime tools export \
  --input-path  /scratch/aduong/Balfour2022/table-L2.qza \
  --output-path  /scratch/aduong/Balfour2022/table-L2

biom convert -i /scratch/aduong/Balfour2022/table-L2/feature-table.biom -o /scratch/aduong/Balfour2022/feature-table.txt --to-tsv