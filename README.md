# getting-and-cleaning-data
Assignment for Coursera

---
title: "README"
author: "Buel Chandler"
date: "December 11, 2015"
output: md_document
---

# Repository Contents

### CODEBOOK.Rmd

CODEBOOK.Rmd contains the data taxonomy, as well as commented steps to follow to go from Raw data of the HCI data collection to a final tidy data format.

### run_analysis.R

The R script run_analysis.R contains the code needed to go from Raw HCI format to our chosen tidy format.

*If you'd like to load the resulting "tidy-ed" dataset, run the following:*
```{r}
data <- read.table("https://s3.amazonaws.com/coursera-uploads/user-e6a850d2b49e0d41ef424ccd/975119/asst-3/9b55b5d0a03311e58f789d2d58b12f15.txt", header = TRUE) 
View(data)
```
# Steps to process Raw -> Tidy (documented fully in CODEBOOK.Rmd)

1. Read and merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement. 
3. Name the activities descriptivly in the data set
4. Appropriately labels the data set with descriptive variable names. 
5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.
