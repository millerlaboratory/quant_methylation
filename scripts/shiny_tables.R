library(readr)
library(dplyr)
library(purrr)



wd <- "~/mcclintock/users/sgibson/output"

# Get the list of file names in the directory
file_names <- list.files(wd, pattern = "\\.tsv$", full.names = TRUE)

# Loop over the file names and read each file
all_data <- list()  # Create a list to store the data from each file
for (file_name in file_names) {
  file_data <- read.delim(file_name)
  all_data <- c(all_data, list(file_data)) 
}

combined_data <- do.call(rbind,all_data)

write_tsv(combined_data, "~/mcclintock/users/sgibson/output/1000g_XX_all_samples.tsv")

diff <- combined_data %>%
  dplyr::group_by(chr,start,stop,cpg,gene,sample) %>%
  reframe(diff=abs(diff(mean_per_mod))) %>%
  tidyr::drop_na()

data <- diff

calculate_density <- function(data) {
  density_x <- density(data$diff)$x
  density_y <- density(data$diff)$y
  
  density_data <- data.frame(sample = unique(data$sample), x = density_x, y = density_y)
  
  return(density_data)
}

# Iterate through the data table and calculate density for each sample
density_data_list <- data %>%
  group_split(sample) %>%
  map(calculate_density)

# Combine the density data into one data table
combined_density_data <- data.frame(bind_rows(density_data_list))


write_tsv(combined_density_data, "~/mcclintock/users/sgibson/output/combined_density_data.tsv")


samples <- data %>%
  group_by(sample) %>%
  summarise()

write_tsv(samples, "~/mcclintock/users/sgibson/output/samples_1000g.tsv")



