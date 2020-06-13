library(tidyverse)
library(RColorBrewer)

dir <- "/output_folder/" #INPUT
setwd(dir)

# Reads file with p-values
loc <- "input_file" # INPUT
gwasResults <- as_tibble(read.table(loc, head=TRUE))

# The following three lines are only necessary if plotting adjusted p-values, but the input_file does not contain BP
loc_nonadj <- "input_nonadj_file" # INPUT
BPdata <- as_tibble(read.table(loc_nonadj, head=TRUE)) %>% select(SNP, BP)
gwasResults <- left_join(gwasResults, BPdata, by="SNP")

# Mutate tibble
data <- gwasResults
data$BP <- as.double(data$BP)
data <- data %>%

  # Compute chromosome size
  group_by(CHR) %>%
  summarise(chr_len=max(BP)) %>%

  # Calculate cumulative position of each chromosome
  mutate(tot=cumsum(chr_len)-chr_len) %>%
  select(-chr_len) %>%

  # Add this info to the initial dataset
  left_join(gwasResults, ., by=c("CHR"="CHR")) %>%

  # Add a cumulative position of each SNP
  arrange(CHR, BP) %>%
  mutate(BPcum=BP+tot)

# Prepare x-axis
axisdf = data %>% group_by(CHR) %>% summarize(center=( max(BPcum) + min(BPcum) ) / 2 )

# Bonferroni Correction - Leave the wanted alpha value uncommented
#alpha <- 0.05 / (nrow(data)) # Manually calculated. Make sure data set doesn't contain NA rows
alpha <- 5e-8 # GWAS standard

# Creates table of significant SNPs
sig <- data %>% filter(GC < alpha)
# ggplot
ggplot(data, aes(x=BPcum, y=-log10(GC))) +
  geom_hline(size=1, color="gray",yintercept = -log10(alpha)) +

  # Show all points & increase size of significant SNPs
  geom_point( aes(color=as.factor(CHR)), alpha=0.8, size=1.3) +
  geom_point(data=sig, aes(color=as.factor(CHR)), alpha=1, size=2.2) +
  scale_colour_manual(values=rep(RColorBrewer::brewer.pal(8,"Set2"),times=3))+

  # custom X axis:
  scale_x_continuous( label = axisdf$CHR, breaks= axisdf$center ) +
  scale_y_continuous(expand = c(0, 0) ) +     # remove space between plot area and x axis

  # Custom the theme:
  theme_bw() +
  theme(
    legend.position="none",
    panel.border = element_blank(),
    panel.grid.major.x = element_blank(),
    panel.grid.minor.x = element_blank()
  ) +
  ggtitle("SNP association with BMI when controlling for sex, age, and diet") +
  xlab("Chromosome Number")

# Export ggplot
output <- "output_jpeb_file" # INPUT
ggsave(output, device="jpeg", width=40,height=30, units = "cm")