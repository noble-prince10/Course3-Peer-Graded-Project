# loading required libraries

library(dplyr)
library(data.table)
library(plyr)

# setting the directory(downloaded from the provided link in the course assignment) 

setwd("E:/R-3.6.2/Testing/UCI HAR DATASET")

# Reading the required datasets and getting to know them

features<-read.table("features.txt", col.names = c("n","features"))
str(features)

activities <- read.table("activity_labels.txt", col.names = c("levels", "activity"))
str(activities)

testSubject <- read.table("test/subject_test.txt", col.names = "subject")
str(testSubject)

x_test <- read.table("test/X_test.txt", col.names = features$features)
str(x_test)

y_test <- read.table("test/Y_test.txt", col.names = "levels")
str(y_test)

trainSubject <- read.table("train/subject_train.txt", col.names = "subject")

x_train <- read.table("train/X_train.txt", col.names = features$features)

y_train <- read.table("train/Y_train.txt", col.names = "levels")

# 1> After getting accustomed to the data, we merge the test and train data

mergeX<-rbind(x_train,x_test)

mergeY<-rbind(y_train,y_test)

mergeSub<-rbind(trainSubject,testSubject)

mergedData<-cbind(mergeX,mergeY,mergeSub)

# mergedData is the required dataset

dim(mergedData)
str(mergedData)
colnames(mergedData)
tbl_df(mergedData)

# 2> After this we extract the required measurements

reqData<- select(mergedData,subject,levels,contains("mean"),contains("std"))
head(reqData)
tbl_df(reqData)
colnames(reqData)

# 3> Using descriptive activity names to name the activities in the data set required

reqData$levels <- activities[reqData$levels,2]
tbl_df(reqData)

# 4> Appropriately labelling the data set with descriptive variable names.

names(reqData)[2] = "activity"
names(reqData)<-gsub("Acc", "Accelerometer", names(reqData))
names(reqData)<-gsub("Gyro", "Gyroscope", names(reqData))
names(reqData)<-gsub("BodyBody", "Body", names(reqData))
names(reqData)<-gsub("Mag", "Magnitude", names(reqData))
names(reqData)<-gsub("^t", "Time", names(reqData))
names(reqData)<-gsub("^f", "Frequency", names(reqData))
names(reqData)<-gsub("tBody", "TimeBody", names(reqData))
names(reqData)<-gsub("-mean()", "Mean", names(reqData), ignore.case = TRUE)
names(reqData)<-gsub("-std()", "STD", names(reqData), ignore.case = TRUE)
names(reqData)<-gsub("-freq()", "Frequency", names(reqData), ignore.case = TRUE)
names(reqData)<-gsub("angle", "Angle", names(reqData))
names(reqData)<-gsub("gravity", "Gravity", names(reqData))

tbl_df(reqData)

# 5> From the data set in step 4, creating a second, independent tidy data set with the average of each variable for each activity and each subject.

finalData<-aggregate(. ~subject + activity, reqData, mean)
finalData<-finalData[order(finalData$subject,finalData$activity),]

tbl_df(finalData)

write.table(finalData, file = "TidyData.txt", row.names = FALSE)