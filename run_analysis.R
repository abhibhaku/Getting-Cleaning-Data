library(plyr);library(dplyr)
#set working directory to "C:/Users/61810969/Documents/R/Practice/UCIHARDataset/samsung"
#downloaded data from link & saved in working directory "C:/Users/61810969/Documents/R/Practice/UCIHARDataset/samsung"
#read training data
trainsubject <-read.table(file.path("train", "subject_train.txt"))
Xtrain <-read.table(file.path("train", "X_train.txt"))
Ytrain <-read.table(file.path("train", "y_train.txt"))
#read test data
testsubject <-read.table(file.path("test", "subject_test.txt"))
Xtest <-read.table(file.path("test", "X_test.txt"))
Ytest <-read.table(file.path("test", "y_test.txt"))
#read features & activity data
feat <-read.table("features.txt")
activlabels <-read.table("activity_labels.txt")
#Merge the training and the test sets to create one data set
samtotal <- rbind(cbind(trainsubject, Xtrain, Ytrain), cbind(testsubject, Xtest,Ytest))
colnames(samtotal) <- c("subject", feat[, 2], "activity") #assign column names
# Extracts only the measurements on the mean and standard deviation for each measurement.
samextract <- grepl("subject|activity|mean|std", colnames(samtotal))
samtotal <-samtotal[,samextract] #data kept in these columns only
# Uses descriptive activity names to name the activities in the data set
samtotal_activlabels <- factor(samtotal$activlabels,activlabels[, 1],activlabels[, 2])
#Appropriately labels the data set with descriptive variable names


samtotal1 <- gsub("^f", "frequencyDomain", samtotal1)
samtotal1 <- gsub("^t", "timeDomain", samtotal1)
samtotal1 <- gsub("Acc", "Accelerometer", samtotal1)
samtotal1 <- gsub("Gyro", "Gyroscope", samtotal1)
samtotal1 <- gsub("Mag", "Magnitude", samtotal1)
samtotal1 <- gsub("Freq", "Frequency", samtotal1)
samtotal1 <- gsub("mean", "Mean", samtotal1)
samtotal1 <- gsub("std", "StandardDeviation", samtotal1)

# correct typo
samtotal1 <- gsub("BodyBody", "Body", samtotal1)


# use new labels as column names
colnames(samtotal) <- samtotal1

#From the data set in step 4, create a second, independent tidy data set with the average of each variable for each activity and each subject
samtotalmeans <- samtotal %>% 
  group_by(subject, activity) %>%
  summarise_all(funs(mean))

# output to file "clean_data.txt"
write.table(samtotalmeans, "clean_data.txt", row.names = FALSE, quote = FALSE)



