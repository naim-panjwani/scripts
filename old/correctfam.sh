#!/bin/bash
# Script to apply updates generated by correctfam.R script
# Syntax: bash correctfam.sh <bplink_filename> <outname>
# Example: bash correctfam.sh UKomni_ceu_elp4_locus.0.8AR2 UKomni_ceu_elp4_locus.0.8AR2_fam_correction


plink --noweb --bfile $1 --update-ids update_id.txt --make-bed --out temp.id.update.$1
plink --noweb --bfile temp.id.update.$1 --update-sex update_sex.txt --make-bed --out temp.sex.update.$1
plink --noweb --bfile temp.sex.update.$1 --update-parents update_parents.txt --make-bed --out $2

rm temp.id.update.$1* temp.sex.update.$1*