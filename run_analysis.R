#******************************************************************************************
# Getting and Cleaning Data - Johns Hopkins University
# Course Project
#******************************************************************************************


# This code performs the following data cleaning/preparation tasks:

# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
# 3. Uses descriptive activity names to name the activities in the data set.
# 4. Appropriately labels the data set with descriptive variable names.
# 5. From the data set in step 4, creates a second, independent tidy data set with the average 
#    of each variable for each activity and each subject.



### Required package: plyr and dplyr 

require(plyr)
require(dplyr)


####### Download the zipped data file ########


if(!file.exists("./data")) {dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile = "./data/ProjectData.zip")

## Unzip the file

unzip ("./data/ProjectData.zip", exdir = "./data")

## Files extracted into the "UCI HAT Dataset" subdirectory. Check contents of this folder

list.files("./data/UCI HAR Dataset", recursive=TRUE)


####### Read files into data frames ###########


### Read the Y_ files into Activity data frames

trainActivity  <- read.table("./data/UCI HAR Dataset/train/y_train.txt", header=F)
testActivity  <- read.table("./data/UCI HAR Dataset/test/y_test.txt", header=F)

str(trainActivity)
# 'data.frame':        7352 obs. of  1 variable:
# $ V1: int  5 5 5 5 5 5 5 5 5 5 ...

str(testActivity)
# 'data.frame':        2947 obs. of  1 variable:
# $ V1: int  5 5 5 5 5 5 5 5 5 5 ...


### Read the Subject files

trainSubject  <- read.table("./data/UCI HAR Dataset/train/subject_train.txt", header=F)
testSubject  <- read.table("./data/UCI HAR Dataset/test/subject_test.txt", header=F)
dim(trainSubject)
#[1] 7352    

dim(testSubject)
#[1] 2947    1


### Read the X_ files into Features data frames

trainFeatures  <- read.table("./data/UCI HAR Dataset/train/X_train.txt", header=F)
testFeatures  <- read.table("./data/UCI HAR Dataset/test/X_test.txt", header=F)
dim(trainFeatures)
#[1] 7352  561      

dim(testFeatures)
#[1] 2947  561      


### Read the features file into Feature Names data frame

featureNames  <- read.table("./data/UCI HAR Dataset/features.txt", header=F)
dim(featureNames)
#[1] 561   2      

head(featureNames, 2)
# V1                   V2
#  1  1 tBodyAcc-mean()-X
#  2  2 tBodyAcc-mean()-Y


######## Combine the Training and Test data sets (by rows) ########

Activity <- rbind(trainActivity, testActivity)
Subject <- rbind(trainSubject, testSubject)
Features <- rbind(trainFeatures, testFeatures)

dim(Activity)
#[1] 10299     1

dim(Subject)
#[1] 10299     1

dim(Features)
#[1] 10299   561


####### Assign column names to each data set ###########

names(Activity) <- c("activity_id")
names(Subject) <- c("subject")

# Assign names from the second column in the featureNames dataset

names(Features) <- featureNames[ , 2]

head(Activity, 2)
#   activity_id
# 1           5
# 2           5

head(Subject, 2)
#   subject
# 1       1
# 2       1

head(Features[, 1:3], 2)  
#     tBodyAcc-mean()-X tBodyAcc-mean()-Y tBodyAcc-mean()-Z
# 1           0.2885845       -0.02029417        -0.1329051
# 2           0.2784188       -0.01641057        -0.1235202

last3_col <- c((ncol(Features)-2):ncol(Features))
head(Features[, last3_col], 2) 
#    angle(X,gravityMean) angle(Y,gravityMean) angle(Z,gravityMean)
# 1           -0.8412468            0.1799406          -0.05862692
# 2           -0.8447876            0.1802889          -0.05431672


######## Combine Subject, Features, and Activity (by column) #########

FeaturesSubject <- cbind(Features, Subject)
AllData <- cbind(FeaturesSubject, Activity)
dim(AllData)
#[1] 10299   563

head(AllData[, 1:3], 2) 
#   tBodyAcc-mean()-X tBodyAcc-mean()-Y tBodyAcc-mean()-Z
# 1         0.2885845       -0.02029417        -0.1329051
# 2         0.2784188       -0.01641057        -0.1235202

last3_col <- c((ncol(AllData)-2):ncol(AllData))
head(AllData[, last3_col], 2) 
#   angle(Z,gravityMean) subject activity_id
# 1          -0.05862692       1           5
# 2          -0.05431672       1           5


###### Extract Features Pertaining to Mean and Std Deviation ########

# Extract row index having "mean()" or "std()" in feature names
# and then extract the feature names corresponding to these rows into a vector

mean_std_index <- grep("mean\\(\\)|std\\(\\)", featureNames[ ,2])
mean_std_features <- featureNames[mean_std_index, 2]

# Pick the columns of interest from AllData

finalCols <- c(as.character(mean_std_features), "subject", "activity_id" )
length(finalCols)
#[1] 68         

head(finalCols, 3)
#[1] "tBodyAcc-mean()-X" "tBodyAcc-mean()-Y" "tBodyAcc-mean()-Z"

tail(finalCols, 3)
#[1] "fBodyBodyGyroJerkMag-std()"      "subject"         "activity_id"                  

FinalData <- AllData[, finalCols]
dim(FinalData)
#[1] 10299    68


####### Use descriptive activity names #######

# Read activity labels

activityLabels <- read.table("./data/UCI HAR Dataset/activity_labels.txt", header=F)
head(activityLabels, 2)
#   V1               V2
# 1  1          WALKING
# 2  2 WALKING_UPSTAIRS

# Assign column names to activityLabels

activityLabels <- rename(activityLabels, activity_id=V1, activity=V2)
head(activityLabels, 2)
#   activity_id         activity
# 1           1          WALKING
# 2           2 WALKING_UPSTAIRS


# Merge FinalData with activityLabels on activity_id 

temp <- merge(FinalData, activityLabels, by="activity_id")
FinalData <- temp[, -1]   # <-- removes the redundant activity_id column

# Check activity names

unique(FinalData$activity)
#[1] WALKING            WALKING_UPSTAIRS   WALKING_DOWNSTAIRS SITTING            STANDING          
#[6] LAYING            
#Levels: LAYING SITTING STANDING WALKING WALKING_DOWNSTAIRS WALKING_UPSTAIRS

# Convert activity names to lowercase and remove the "_" character

FinalData <- mutate(FinalData, activity=as.factor(tolower(sub("_", "", FinalData$activity))))

# Check the transformed acticity names

unique(FinalData$activity)
#[1] walking     walkingupstairs     walkingdownstairs    sitting     standing     laying           
#Levels: laying sitting standing walking walkingdownstairs walkingupstairs


####### Appropriately label the dataset with descriptive names ########

# Remove parenthesis from feature labels

names(FinalData) <- gsub("\\(|\\)", "", names(FinalData))

# Substitute patterns to to make labels clearer

names(FinalData) <- gsub("^t", "time", names(FinalData))
names(FinalData) <- gsub("^f", "frequency", names(FinalData))
names(FinalData) <- gsub("Acc", "Acceleration", names(FinalData))
names(FinalData) <- gsub("GyroJerk", "AngularAcceleration", names(FinalData))
names(FinalData) <- gsub("Gyro", "AngularSpeed", names(FinalData))
names(FinalData) <- gsub("Mag", "Magnitude", names(FinalData))
names(FinalData) <- gsub("BodyBody", "Body", names(FinalData))

names(FinalData) <- gsub("mean", "Mean", names(FinalData))
names(FinalData) <- gsub("std", "StandardDeviation", names(FinalData))

# Check new name

names(FinalData)


###### Summarize data for combination of subject and activity #######

# Final data has multiple measurements pertaining to multiple windows for each
# subject and activity, combine them using average


TidyData <- ddply(FinalData, c("subject", "activity"), numcolwise(mean))
TidyData <- TidyData[order(TidyData$subject, TidyData$activity), ]
dim(TidyData)
#[1] 180  68

write.table(TidyData, file="tidydata.txt", row.name=F)

# Read the .txt file back into a data frame

ReadBack <- read.table("tidydata.txt", header=TRUE)
dim(ReadBack)
#[1] 180  68






