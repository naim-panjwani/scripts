#!/bin/bash
# Simple script to extract the outlier individuals from the file generated by smartpca
# Syntax: bash extract_pca_outliers <smartpca_output_filename> <output_filename>
# Example: bash extract_pca_outliers.sh 44_pca.out 46_outliers.txt 

grep 'REMOVED' $1 |sed 's/.*outlier \(.*:.*\) iter .*/\1/g' |tr ':' ' ' >$2
