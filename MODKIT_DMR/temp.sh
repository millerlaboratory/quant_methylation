OUTPUT_DIR=/n/users/sgibson/1000g_methylation/modkit_v0.1.11/modkit_DMR_chrX

cd $OUTPUT_DIR

for file in $OUTPUT_DIR/*_labeled_labeled.bed; do
    sample=$(echo "${file##*/}" | cut -d'.' -f1)
   awk -F'\t' '{$NF=""; sub(/[ \t]+$/, ""); print}' $file > ${sample}_chrX_DMR_scores.bed
    rm $file
done

cat *.bed > 1000g_chrX_DMR_scored.bed
