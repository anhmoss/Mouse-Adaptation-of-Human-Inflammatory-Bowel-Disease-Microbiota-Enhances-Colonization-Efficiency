#!/bin/bash

#SBATCH --partition=Pisces
#SBATCH --time=08:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=16
#SBATCH --mem=100GB

module load qiime2

qiime tools import \
  --type 'SampleData[PairedEndSequencesWithQuality]' \
  --input-path /scratch/aduong/Balfour2022/220824_UNC23_0386_000000000-KJC2N-in/220824_UNC23_0386_000000000-KJC2N/fasta \
  --input-format CasavaOneEightSingleLanePerSampleDirFmt \
  --output-path /scratch/aduong/Balfour2022/demux-paired-end.qza

qiime tools import \
  --type 'SampleData[SequencesWithQuality]' \
  --input-path /scratch/aduong/Balfour2022/220824_UNC23_0386_000000000-KJC2N-in/220824_UNC23_0386_000000000-KJC2N/R1 \
  --input-format CasavaOneEightSingleLanePerSampleDirFmt \
  --output-path /scratch/aduong/Balfour2022/demux-single-end.qza

qiime dada2 denoise-single \
 --p-trim-left 10 \
 --p-trunc-len 180 \
 --i-demultiplexed-seqs /scratch/aduong/Balfour2022/demux-single-end.qza \
 --p-chimera-method pooled \
 --p-min-fold-parent-over-abundance 100 \
 --p-n-threads  30 \
 --output-dir /scratch/aduong/Balfour2022/se/dada2/


qiime feature-classifier classify-sklearn \
      --i-classifier /projects/afodor_research/database/silva-138-99-nb-classifier.qza \
      --p-n-jobs 1 \
      --i-reads /scratch/aduong/Balfour2022/se/dada2/representative_sequences.qza \
      --o-classification /scratch/aduong/Balfour2022/se/dada2/taxonomy.qza

qiime tools export \
      --input-path  /scratch/aduong/Balfour2022/se/dada2/representative_sequences.qza \
      --output-path  /scratch/aduong/Balfour2022/se/dada2/representative_sequences

qiime tools export \
      --input-path  /scratch/aduong/Balfour2022/se/dada2/taxonomy.qza \
      --output-path  /scratch/aduong/Balfour2022/se/dada2/taxonomy

qiime tools export \
      --input-path /scratch/aduong/Balfour2022/se/dada2/table.qza \
      --output-path  /scratch/aduong/Balfour2022/se/dada2/table

qiime tools export \
      --input-path /scratch/aduong/Balfour2022/se/dada2/denoising_stats.qza  \
      --output-path  /scratch/aduong/Balfour2022/se/dada2/denoising_stats


biom add-metadata \
 --input-fp /scratch/aduong/Balfour2022/se/dada2/table/feature-table.biom \
 --observation-metadata-fp /scratch/aduong/Balfour2022/se/dada2/taxonomy/taxonomy.tsv \
 --output-fp /scratch/aduong/Balfour2022/se/dada2/biom-with-taxonomy.biom  \
 --sc-separated taxonomy --observation-header OTUID,taxonomy

biom convert -i /scratch/aduong/Balfour2022/se/dada2/biom-with-taxonomy.biom -o /scratch/aduong/Balfour2022/se/dada2/biom-with-taxonomy.txt --to-tsv --header-key taxonomy
