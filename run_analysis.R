
## Set Working Directory
> setwd("D:/Coursera/getting & cleaning data")
> getwd()
[1] "D:/Coursera/getting & cleaning data"

## Download Data and Unzip to a folder under Data directory in the path
fileUrl <- "http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="data/getdata-projectfiles-UCI HAR Dataset.zip",method="curl")
unzip(zipfile="data/getdata-projectfiles-UCI HAR Dataset.zip",exdir="data")
path_rf <- file.path("./data" , "UCI HAR Dataset")
files<-list.files(path_rf, recursive=TRUE)
## read data

ActivityTest  <- read.table(file.path(path_rf, "test" , "Y_test.txt" ),header = FALSE)
ActivityTraining <- read.table(file.path(path_rf, "train", "Y_train.txt"),header = FALSE)
SubjectTraining <- read.table(file.path(path_rf, "train", "subject_train.txt"),header = FALSE)
SubjectTest  <- read.table(file.path(path_rf, "test" , "subject_test.txt"),header = FALSE)
FeaturesTest  <- read.table(file.path(path_rf, "test" , "X_test.txt" ),header = FALSE)
FeaturesTraining <- read.table(file.path(path_rf, "train", "X_train.txt"),header = FALSE)
## Verify
str(dataActivityTest)
'data.frame':   2947 obs. of  1 variable:
 $ V1: int  5 5 5 5 5 5 5 5 5 5 ...

## Step 1 Merge and create a data set

Subject <- rbind(SubjectTraining, SubjectTest)
Activity<- rbind(ActivityTraining, ActivityTest)
Features<- rbind(FeaturesTraining, FeaturesTest)
names(Subject)<-c("subject")
names(Activity)<- c("activity")
dataFeaturesNames <- read.table(file.path(path_rf, "features.txt"),head=FALSE)
names(Features)<- FeaturesNames$V2
Combine <- cbind(Subject, Activity)
Data <- cbind(Features, Combine)

## Step 2: Mean and SD Data Extraction
FeaturesNames<-dataFeaturesNames$V2[grep("mean\\(\\)|std\\(\\)", dataFeaturesNames$V2)]
selectedNames<-c(as.character(FeaturesNames), "subject", "activity" )
Data<-subset(Data,select=selectedNames)
## Check data with str(Data)

## sep 3 and 4 Labeling the activity names:

activityLabels <- read.table(file.path(path_rf, "activity_labels.txt"),header = FALSE)

names(Data)<-gsub("^t", "time", names(Data))
names(Data)<-gsub("^f", "frequency", names(Data))
names(Data)<-gsub("Acc", "Accelerometer", names(Data))
names(Data)<-gsub("Gyro", "Gyroscope", names(Data))
names(Data)<-gsub("Mag", "Magnitude", names(Data))
names(Data)<-gsub("BodyBody", "Body", names(Data))

## step 5 aggregate and create a tidy data file
 install.packages("plyr")
 library(plyr);
Data2<-aggregate(. ~subject + activity, Data, mean)
Data2<-Data2[order(Data2$subject,Data2$activity),]
write.table(Data2, file = "tidydata.txt",row.name=FALSE)
