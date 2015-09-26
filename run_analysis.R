#
#
# we assume you're running this from a directory which has a sub-directory
# "UCI HAR Dataset" with the assigned files and directories within it
#

## setwd("C:/Users/Buel/datasciencecoursera/Getting and Cleaning Data")
suppressMessages(library(dplyr))

## the next bit of code is to get the data, then merge what is required to 
## satisfy Part 1 (of 5) of the assignment

# get the activity labels (e.g, walking, sitting) 6 obs, 2 vble
act <- read.table("UCI HAR Dataset\\activity_labels.txt")

# get the filtered computed features (e.g., tBodyAccMag-mean(), etc) 561 obs, 2 vble
feat <- read.table("UCI HAR Dataset\\features.txt",check.names = FALSE)

# get feature measurements for ML test population. 2947 obs, 561 vble. The vble
# map to the 561 obs of feat
xtest <- read.table("UCI HAR Dataset\\test\\X_test.txt")
# this maps activity to an obs in xtest. 2947 obs, 1 vble 
atest <- read.table("UCI HAR Dataset\\test\\y_test.txt")
# this maps the subject to an obs in xtest. 2947 obs, 1 vble 
stest <- read.table("UCI HAR Dataset\\test\\subject_test.txt")

# as above, but for the ML training population. 7352 obs, 561 vble
xtrain <- read.table("UCI HAR Dataset\\train\\X_train.txt")
# this maps activity to an obs in xtrain. 7352 obs, 1 vble 
atrain <- read.table("UCI HAR Dataset\\train\\y_train.txt")
# this maps the subject to an obs in xtest. 7352 obs, 1 vble 
strain <- read.table("UCI HAR Dataset\\train\\subject_train.txt")

# concatenate the data
subject <- rbind(stest,strain)
activity <- rbind(atest,atrain)
measures <- rbind(xtest,xtrain)

# add column names to measurements, activity, and subject tables
# note that feature names were not unique, so we make them so with make.names call
colnames(measures) <- t(make.names(feat$V2, unique = TRUE, allow_ = TRUE))
colnames(activity) <- "activity"
colnames(subject) <- "subject"

# now create the coprehensive "raw" data table
rawdata <- cbind(subject, activity, measures)

# thus ends #1 of the assignment

## Part 2 of assignment is to extract only columns that deal with "mean"
## or std (standard deviation), plus our newly added subject and activity data

extractdata <- rawdata %>% 
                select(subject, 
                       activity,
                       contains("mean", ignore.case = TRUE),
                       contains("std", ignore.case = TRUE))


## Part 3. we transmute the activity column from integer to actual text of the activity
## from our earlier read of the "act" dataset. Make it a factor

extractdata$activity = factor(extractdata$activity, labels = act$V2)

## Part 4. prettyfy the feature varible names.
## 
## towards the end of Part 1, the 561 features columns in the raw data were
## named from the "features.txt" table  The R function make.names was used to do
## a first pass clean-up of the names to allow us to id which columns contained
## "mean" and "std" attributes. That first pass cleanup was done with (from above):
##   colnames(measures) <- t(make.names(feat$V2, unique = TRUE, allow_ = TRUE))
##
## However, the column names still contained some '...', '..', '.' which were 
## substituted for invalid characters and such. Here we clean those up

# 1st convert '...' which appear followed by an axis indicater to '_'
names(extractdata) <- gsub("\\.\\.\\.", "_", names(extractdata))

# 2nd convert '..' to null, as they appear at end of names in the case
names(extractdata) <- gsub("\\.\\.", "", names(extractdata))

# 3rd convert are the singleton '.'  Here we have them both embeded between characters,
# or at the very end. The former we convert to '_', the later we drop
names(extractdata) <- gsub("\\.$", "", names(extractdata)) # '.' at end
names(extractdata) <- gsub("\\.", "_", names(extractdata)) # '.' embedded

# 4th convert initial 'f' to 'freq_', 't' to 'time_'
names(extractdata) <- gsub("^f", "freq_", names(extractdata))
names(extractdata) <- gsub("^t", "time_", names(extractdata))

# 5th convert 'angle_t' to 'angle_time_'
names(extractdata) <- gsub("angle_t", "angle_time_", names(extractdata))

# 6th convert 'meanFreq' to 'mean_Freq'
names(extractdata) <- gsub("meanFreq", "mean_Freq", names(extractdata))

# 7th and last convert. tidy up those few 'Mean' to '_mean_'
names(extractdata) <- gsub("Mean", "_mean_", names(extractdata))
names(extractdata) <- gsub("__", "_", names(extractdata))
names(extractdata) <- gsub("_$", "", names(extractdata))

## Part 5 we create a tidy dataset that has the mean of all the features 
## grouped by subject and activity
tidydata <- extractdata %>%
    group_by(subject, activity) %>%
    summarise_each(funs(mean))

## now we write it out
write.table(tidydata, file = "tidydata.txt", row.names = FALSE)


