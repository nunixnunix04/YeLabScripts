install.packages("qqman",repos="https://cran.univ-paris1.fr/",lib="~" ) # location of installation can be changed but has to correspond with the library location 
library("qqman",lib.loc="~")

dir <- "/directory/" # INPUT
setwd(dir)
loc <- "input_file" #INPUT
results_log <- read.table(loc, head=TRUE) # Might need to change head=TRUE to =FALSE

jpeg("file_name.jpeg") # INPUT
qq(results_log$P, main = "Title") #INPUT
dev.off()
