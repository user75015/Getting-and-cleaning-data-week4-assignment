rm(list = ls(all = TRUE))
library(plyr) # load plyr first, then dplyr
library(data.table) # a prockage that handles dataframe better
library(dplyr) # for fancy data table manipulations and organization
rm(list = ls(all = TRUE))
library(plyr) # load plyr first, then dplyr
library(data.table) # a prockage that handles dataframe better
install.packages("data.table")
library(data.table) # a prockage that handles dataframe better
library(dplyr) # for fancy data table manipulations and organization
temp <- tempfile()
download.file("http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",temp)
#unloaded zip file to temp
#Unzip the file
unzip(temp, list = TRUE) #This provides the list of variables and I choose the ones that are applicable for this data set
library(readr)
week_4_assignment <- read_csv("week 4 assignment.Rproj")
View(week_4_assignment)
YTest <- read.table(unzip(temp, "UCI HAR Dataset/test/y_test.txt"))
XTest <- read.table(unzip(temp, "UCI HAR Dataset/test/X_test.txt"))
SubjectTest <- read.table(unzip(temp, "UCI HAR Dataset/test/subject_test.txt"))
YTrain <- read.table(unzip(temp, "UCI HAR Dataset/train/y_train.txt"))
XTrain <- read.table(unzip(temp, "UCI HAR Dataset/train/X_train.txt"))
SubjectTrain <- read.table(unzip(temp, "UCI HAR Dataset/train/subject_train.txt"))
Features <- read.table(unzip(temp, "UCI HAR Dataset/features.txt"))
unlink(temp) # very important to remove this
# Data Cleaning
# Fix Column names
colnames(XTrain) <- t(Features[2])
colnames(XTrain) <- t(Features[2])
colnames(XTest) <- t(Features[2])
# Merge of X and Y Train set align since there is no common ID
XTrain$activities <- YTrain[, 1]
XTrain$participants <- SubjectTrain[, 1]
XTest$activities <- YTest[, 1]
XTest$participants <- SubjectTest[, 1]
# 1 - Merges the training and the test sets to create one data set.
Master <- rbind(XTrain, XTest)
duplicated(colnames(Master))
Master <- Master[, !duplicated(colnames(Master))]
# 2- Extracts only the measurements on the mean and standard deviation for each measurement.
Mean <- grep("mean()", names(Master), value = FALSE, fixed = TRUE)
#In addition, we need to include 555:559 as they have means and are associated with the gravity terms
Mean <- append(Mean, 471:477)
InstrumentMeanMatrix <- Master[Mean]
# For STD
STD <- grep("std()", names(Master), value = FALSE)
InstrumentSTDMatrix <- Master[STD]
# 3- Uses descriptive activity names to name the activities in the data set
# Changing the class is useful for replacing strings
Master$activities <- as.character(Master$activities)
Master$activities[Master$activities == 1] <- "Walking"
Master$activities[Master$activities == 2] <- "Walking Upstairs"
Master$activities[Master$activities == 3] <- "Walking Downstairs"
Master$activities[Master$activities == 4] <- "Sitting"
Master$activities[Master$activities == 5] <- "Standing"
Master$activities[Master$activities == 6] <- "Laying"
Master$activities <- as.factor(Master$activities)
# 4- Appropriately labels the data set with descriptive variable names.
names(Master)  # survey the data
# ^t-time; ^f-frequency; Acc-Accelerator; Gyro-Gyroscope; Mag-Magnitude
# Use gsub to replace that list
names(Master) <- gsub("Acc", "Accelerator", names(Master))
names(Master) <- gsub("Mag", "Magnitude", names(Master))
names(Master) <- gsub("Gyro", "Gyroscope", names(Master))
names(Master) <- gsub("^t", "time", names(Master))
names(Master) <- gsub("^f", "frequency", names(Master))
# Change participants names
Master$participants <- as.character(Master$participants)
Master$participants[Master$participants == 1] <- "Participant 1"
Master$participants[Master$participants == 2] <- "Participant 2"
Master$participants[Master$participants == 3] <- "Participant 3"
Master$participants[Master$participants == 4] <- "Participant 4"
Master$participants[Master$participants == 5] <- "Participant 5"
Master$participants[Master$participants == 6] <- "Participant 6"
Master$participants[Master$participants == 7] <- "Participant 7"
Master$participants[Master$participants == 8] <- "Participant 8"
Master$participants[Master$participants == 9] <- "Participant 9"
Master$participants[Master$participants == 10] <- "Participant 10"
Master$participants[Master$participants == 11] <- "Participant 11"
Master$participants[Master$participants == 12] <- "Participant 12"
Master$participants[Master$participants == 13] <- "Participant 13"
Master$participants[Master$participants == 14] <- "Participant 14"
Master$participants[Master$participants == 15] <- "Participant 15"
Master$participants[Master$participants == 16] <- "Participant 16"
Master$participants[Master$participants == 17] <- "Participant 17"
Master$participants[Master$participants == 18] <- "Participant 18"
Master$participants[Master$participants == 19] <- "Participant 19"
Master$participants[Master$participants == 20] <- "Participant 20"
Master$participants[Master$participants == 21] <- "Participant 21"
Master$participants[Master$participants == 22] <- "Participant 22"
Master$participants[Master$participants == 23] <- "Participant 23"
Master$participants[Master$participants == 24] <- "Participant 24"
Master$participants[Master$participants == 25] <- "Participant 25"
Master$participants[Master$participants == 26] <- "Participant 26"
Master$participants[Master$participants == 27] <- "Participant 27"
Master$participants[Master$participants == 28] <- "Participant 28"
Master$participants[Master$participants == 29] <- "Participant 29"
Master$participants[Master$participants == 30] <- "Participant 30"
Master$participants <- as.factor(Master$participants)
# 5- Create a tidy data set
Master.dt <- data.table(Master)
#This takes the mean of every column broken down by participants and activities
TidyData <- Master.dt[, lapply(.SD, mean), by = 'participants,activities']
write.table(TidyData, file = "Tidy.txt", row.names = FALSE)
Tidy <- read.csv("C:/Users/jtheb/OneDrive/Desktop/Coursera/Data Science/Data Cleaning/Week 4/week 4 assignment/Tidy.txt", header=FALSE)