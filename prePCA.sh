#!/bin/bash
# Make sure extended_ld_regions.txt is present locally

dataset=$1
prefix=$2

echo "1. Listing non-autosomal chromosome SNPs, indels and ambiguous SNPs to delete"
awk '$1 < 1 || $1 > 22' ${dataset}.bim |cut -f2 >snps_to_rm.txt
#grep ^23 ${dataset}.bim |cut -f2 >snps_to_rm.txt
awk '$5 == "I" || $6 == "I" || $5 == "D" || $6 == "D"' ${dataset}.bim |cut -f2 >>snps_to_rm.txt
awk '($5 == "A" && $6 == "T") || ($5 == "T" && $6 == "A") || ($5 == "G" && $6 == "C") || ($5 == "C" && $6 == "G")' ${dataset}.bim |cut -f2 >>snps_to_rm.txt
awk '($5 != "A" && $5 != "T" && $5 != "G" && $5 != "C") || ($6 != "A" && $6 != "T" && $6 != "G" && $6 != "C")' ${dataset}.bim |cut -f2 >>snps_to_rm.txt

plink --noweb --bfile ${dataset} --exclude snps_to_rm.txt --make-bed --out ${prefix}-bad_snps_rm


echo "2. Remove long LD region, rare alleles, and prune it"
if [ ! -e extended_ld_regions.txt ]; then ln -s ~/scripts/extended_ld_regions.txt; fi
plink --noweb --bfile ${prefix}-bad_snps_rm --exclude extended_ld_regions.txt --range --make-bed --out ${prefix}-longregionRemoved
#prune
plink --noweb --bfile ${prefix}-longregionRemoved --maf 0.05 --make-bed --out ${prefix}-MAFlongregionRemoved
plink --noweb --bfile ${prefix}-MAFlongregionRemoved --indep-pairwise 1500 100 0.2 --out ${prefix}-pruned
plink --noweb --bfile ${prefix}-MAFlongregionRemoved --extract ${prefix}-pruned.prune.in --make-bed --out ${prefix}-pruned

rm ${prefix}-bad_snps_rm* ${prefix}-longregionRemoved* ${prefix}-MAFlongregionRemoved*

