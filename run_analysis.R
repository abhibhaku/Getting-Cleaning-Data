# Getting & Cleaning Data Project

## The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis.

## One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:
  
## http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

## Here are the data for the project:
  
## https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

## You should create one R script called run_analysis.R that does the following.

## Merges the training and the test sets to create one data set.
## Extracts only the measurements on the mean and standard deviation for each measurement.
## Uses descriptive activity names to name the activities in the data set
## Appropriately labels the data set with descriptive variable names.
## Creates a second, independent tidy data set with the average of each variable for each activity and each subject.


## setting current working directory

setwd("D:/ISB Co 2018/Coursera/Data Science Specialization/Getting & Cleaning Data")

## unzipping the downloaded data file and saving in current working directory

library(plyr)
library(dplyr)

data_zip = "D:/ISB Co 2018/Coursera/Data Science Specialization/Getting & Cleaning Data/getdata%2Fprojectfiles%2FUCI HAR Dataset.zip"

unzip(data_zip)

setwd("D:/ISB Co 2018/Coursera/Data Science Specialization/Getting & Cleaning Data/UCI HAR Dataset/samsung")

# read all .txt files

subject_test <- read.table("subject_test.txt")
subject_train <- read.table("subject_train.txt")
X_test <- read.table("X_test.txt")
X_train <- read.table("X_train.txt")
y_test <- read.table("y_test.txt")
y_train <- read.table("y_train.txt")
features <- read.table("features.txt")
activity_labels <- read.table("activity_labels.txt")

# merge files

subject_merge <- rbind(subject_train,subject_test)
X_merge <- rbind(X_train,X_test)
y_merge <- rbind(y_train,y_test)

# rename columns

names(subject_merge) <- c("subject")
names(X_merge) <- features[,2]
names(y_merge) <- c("activity")

# combine all in final merged one data frame

samsung_final <- cbind(X_merge,subject_merge,y_merge)

# subset final merged data frame to consider only those columns with "mean" & "std" in their titles

k <- grep("mean\\(\\)|std\\(\\)",names(samsung_final), value=TRUE)
samsung_s <- samsung_final[,k]
samsung_s <- cbind(samsung_s,subject_merge,y_merge)

# replace the activity column numerical variables to descriptive name factor variables

samsung_s$activity <- factor(samsung_s$activity,labels=activity_labels[,2])

# labelling data set with appropriate variable names - eg., prefix t is replaced by time, acc by accelerometer etc.

names(samsung_s) <- gsub("^t","time",names(samsung_s))
names(samsung_s) <- gsub("^f","frequency",names(samsung_s))
names(samsung_s) <- gsub("Acc","Accelerometer",names(samsung_s))
names(samsung_s) <- gsub("Gyro","Gyroscope",names(samsung_s))
names(samsung_s) <- gsub("Mag","Magnitude",names(samsung_s))
names(samsung_s) <- gsub("BodyBody","Body",names(samsung_s))

# create a new independent tidy data set with the average of each variable for each activity and each subject based on the final data set

samsung_f <- aggregate(.~subject+activity,samsung_s,mean)

samsung_data <- samsung_f[order(samsung_f$subject,samsung_f$activity),]

write.table(samsung_data, file = "tidydata.txt",row.name=FALSE)

