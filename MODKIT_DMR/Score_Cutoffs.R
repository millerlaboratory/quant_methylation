library(dplyr)
library(readr)
library(ggplot2)
library(tidyr)
library(plotly)


chrX_DMR_scored <- read.table("~/mcclintock/users/sgibson/1000g_methylation/modkit_v0.1.11/modkit_DMR_chrX/1000g_chrX_DMR_scored.bed", quote="\"", comment.char="")
predicted_skew <- read.table("~/mcclintock/users/sgibson/1000g_methylation/modkit_v0.1.11/modkit_DMR_chrX/most_skewed.txt", quote="\"", comment.char="") %>%
  dplyr::rename(sample = "V1") %>%
  dplyr::mutate(skew="skew")

header <- c("chr", "start", "stop", "cpg", "score", "hp1_count", "hp1_total", "hp2_counts", "hp2_total", "hp1_frac", "hp2_frac", "sample")

names(chrX_DMR_scored) <- header

status <- left_join(chrX_DMR_scored, predicted_skew)

status$skew <- status$skew %>% replace_na("random")



filtered_DMR_scores <- status %>%
  dplyr::filter(hp1_total > 0) %>%
  dplyr::filter(hp2_total > 0) %>%
  dplyr::filter(cpg != "cpg.27475")






#distribution at RP2

RP2 <- status %>%
  dplyr::filter(cpg == "cpg.27155")

ggplot2::ggplot(RP2, aes(x=score, stat="identity", fill=skew)) +
  geom_dotplot()


mean_score <- filtered_DMR_scores %>%
  dplyr::group_by(chr,start,stop,cpg) %>%
  dplyr::reframe(mean_score=mean(score))

ggplot(mean_score, aes(x=mean_score, stat="identiy")) +
  geom_histogram()
         



ggplot(mean_score, aes(x=(start+stop)/2,y=mean_score)) +
  geom_point(shape=21,color="black", size=4)



HG03022 <- filtered_DMR_scores %>%
  dplyr::filter(sample == "HG03022")


ggplot(HG03022, aes(x=start, y=score)) +
  geom_point()

ggplot(HG03022, aes(x=score, stat="identiy")) +
  geom_histogram()


HG01414 <- filtered_DMR_scores %>%
  dplyr::filter(sample == "HG01414")


ggplot(HG01414, aes(x=score, stat="identiy")) +
  geom_histogram()




mean_score_sample <- filtered_DMR_scores %>%
  dplyr::group_by(sample, skew) %>%
  dplyr::reframe(mean=mean(score))




ggplot2::ggplot(mean_score_sample, aes(x=mean, stat="identity", fill=skew)) +
  geom_dotplot()

#Average score over 200 (before filtering uninformative cpgs)



#Remove cpgs where the mean score is less than 20

pass_cpg <- mean_score %>%
  dplyr::filter(mean_score > 20) %>%
  dplyr::select(cpg)

cutoff_1 <- left_join(pass_cpg, filtered_DMR_scores)



mean_score_sample_2 <- cutoff_1 %>%
  dplyr::group_by(sample, skew) %>%
  dplyr::reframe(mean=mean(score))


ggplot2::ggplot(mean_score_sample_2, aes(x=mean, stat="identity", fill=skew)) +
  geom_dotplot()


###############################################################################

ratio <- filtered_DMR_scores %>%
  tidyr::separate(hp1_frac, into = c("mod", "h1_frac"), sep=":") %>%
  tidyr::separate(hp2_frac, into = c("mod", "h2_frac"), sep=":")  

ratio$h1_frac <- as.numeric(ratio$h1_frac)
ratio$h2_frac <- as.numeric(ratio$h2_frac)


ratio_calc <- ratio %>%
  dplyr::mutate(ratio = ifelse(h1_frac <= h2_frac, h1_frac/h2_frac, h2_frac/h1_frac)) %>%
  dplyr::filter(cpg != "cpg.27475")


RP2_ratio <- ratio_calc %>%
  dplyr::filter(cpg == "cpg.27155")

plot <- ggplot(ratio_calc, aes(x=score, y=ratio)) +
  geom_point()


ggplot(RP2_ratio, aes(x=score, stat="identity")) +
  geom_histogram(binwidth=30)

ggplotly(plot)
  
HG02694 <- ratio_calc %>%
  filter(sample == "HG02694") #missing over 200 cpgs, low phasing coverage at a lot of them


#Make a skew assignment based on AR region DMR score, filter out non

AR_1000g <- read.delim("~/mcclintock/users/sgibson/1000g_methylation/modkit_v0.1.11/modkit_DMR_chrX/AR_1000g.bed", header=FALSE)

names(AR_1000g) <- header

filtered_AR <- AR_1000g %>%
dplyr::filter(hp1_total > 0) %>%
  dplyr::filter(hp2_total > 0)


ggplot(filtered_AR, aes(x=score, stat="identity")) +
  geom_histogram(binwidth=30)


x_inactivation_informative_cpgIslands <- read.csv("~/mcclintock/users/sgibson/reference/x_inactivation_informative_cpgIslands.tsv", sep="")


informative <- left_join(x_inactivation_informative_cpgIslands, filtered_DMR_scores)


mean_informative <- informative %>%
  dplyr::group_by(chr,start,stop,cpg) %>%
  reframe(mean=mean(score))


ggplot(mean_informative, aes(x=mean, stat="identity")) +
  geom_histogram(binwidth=30)

#mean of 50 or greater in the informative sites that were called "manually"

ggplot(filtered_DMR_scores, aes(x=score , stat="identity")) +
  geom_histogram(binwidth=100)


score_range <- filtered_DMR_scores %>%
  group_by(chr,start,stop, cpg) %>%
  reframe(min=min(score),max=max(score),range=max-min)

ggplot(score_range, aes(x=range, stat="identity")) +
  geom_histogram(binwidth=50)

ucsc_cpg_num <- read.delim("~/mcclintock/users/sgibson/reference/ucsc_cpg_num.bed", header=FALSE)


h <- c("chr", "start", "stop", "num")

names(ucsc_cpg_num) <- h

chrX_num <- ucsc_cpg_num %>%
  dplyr::filter(chr == "chrX") %>%
  dplyr::mutate(min=num*5)

test <- left_join(RP2_ratio, chrX_num)








