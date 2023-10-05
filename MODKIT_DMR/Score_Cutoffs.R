library(dplyr)
library(readr)
library(ggplot2)


chrX_DMR_scored <- read.table("~/mcclintock/users/sgibson/1000g_methylation/modkit_v0.1.11/modkit_DMR_chrX/1000g_chrX_DMR_scored.bed", quote="\"", comment.char="")
predicted_skew <- read.table("~/mcclintock/users/sgibson/1000g_methylation/modkit_v0.1.11/modkit_DMR_chrX/predicted_skew.txt", quote="\"", comment.char="") %>%
  dplyr::rename(sample = "V1")

header <- c("chr", "start", "stop", "cpg", "score", "hp1_count", "hp1_total", "hp2_counts", "hp2_total", "hp1_frac", "hp2_frac", "sample")

names(chrX_DMR_scored) <- header

#distribution at RP2

RP2 <- chrX_DMR_scored %>%
  dplyr::filter(cpg == "cpg.27155")

ggplot2::ggplot(RP2, aes(x=score, stat="identity")) +
  geom_histogram(binwidth = 20)


mean_score <- chrX_DMR_scored %>%
  dplyr::group_by(chr,start,stop,cpg) %>%
  dplyr::reframe(mean_score=mean(score))


ggplot(mean_score, aes(x=(start+stop)/2,y=mean_score)) +
  geom_point(shape=21,color="black", size=4)


skew <- left_join(predicted_skew, chrX_DMR_scored)

RP2_skew <- skew %>%
  dplyr::filter(cpg == "cpg.27155")
