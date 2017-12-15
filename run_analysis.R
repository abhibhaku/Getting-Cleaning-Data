library(plyr);library(dplyr)
#set working directory to "C:/Users/61810969/Documents/R/Practice/UCIHARDataset/samsung"
#downloaded data from link & saved in working directory "C:/Users/61810969/Documents/R/Practice/UCIHARDataset/samsung"
#read training data

trainsubject <-read.table(file.path("train/subject_train.txt"))
Xtrain <-read.table(file.path("train", "X_train.txt"))
Xtrain <-read.table(file.path("train/X_train.txt"))
Ytrain <-read.table(file.path("train/y_train.txt"))
testsubject <-read.table(file.path("test/subject_test.txt"))
Xtest <-read.table(file.path("test/X_test.txt"))
Ytest <-read.table(file.path("test/y_test.txt"))

#Merge the training and the test sets to create one data set

X1 <-rbind(Xtrain, Xtest)
Y1 <-rbind(Ytrain, Ytest)
Subject1 <-rbind(trainsubject,testsubject)

# Extract only the measurements on the mean and standard deviation for each measurement

feat <-read.table("features.txt")
mnsfeat <- grep("-(mean|std)\\(\\)", feat[, 2])
X1 <- X1[, mnsfeat]
names(X1) <- feat[mnsfeat, 2]

# Use descriptive activity names to name the activities in the data set

actlabels <- read.table("activity_labels.txt")
Y1[, 1] <- actlabels[Y1[, 1], 2]
names(Y1) <- "activity"

#Appropriately label the data set with descriptive variable names

names(Subject1) <- "subject"
Z1 <- cbind(X1,Y1,Subject1)

# Create a second, independent tidy data set with the average of each variable for each activity and each subject

clear_data <- ddply(Z1, .(subject, activity), function(X) colMeans(X[, 1:66]))
write.table(clear_data, "clear_data.txt", row.name=FALSE)
