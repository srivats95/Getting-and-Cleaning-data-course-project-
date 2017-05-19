library(plyr)

# Downloading dataset
if(!file.exists("C:/Users/SONY/Documents")){dir.create("C:/Users/SONY/Documents")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="C:/Users/SONY/Documents/Dataset.zip")

# Unzip dataSet to /data directory
unzip(zipfile="C:/Users/SONY/Documents/Dataset.zip",exdir="C:/Users/SONY/Documents")


# Merging the training and the test sets to create one data set:

# Reading files

# Reading trainings tables:
x_train <- read.table("C:/Users/SONY/Documents/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("C:/Users/SONY/Documents/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("C:/Users/SONY/Documents/UCI HAR Dataset/train/subject_train.txt")

# Reading testing tables:
x_test <- read.table("C:/Users/SONY/Documents/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("C:/Users/SONY/Documents/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("C:/Users/SONY/Documents/UCI HAR Dataset/test/subject_test.txt")

# Reading feature vector:
features <- read.table('C:/Users/SONY/Documents/UCI HAR Dataset/features.txt')

# Reading activity labels:
activityLabels = read.table('C:/Users/SONY/Documents/UCI HAR Dataset/activity_labels.txt')

# Assigning column names:
colnames(x_train) <- features[,2] 
colnames(y_train) <-"activityId"
colnames(subject_train) <- "subjectId"

colnames(x_test) <- features[,2] 
colnames(y_test) <- "activityId"
colnames(subject_test) <- "subjectId"

colnames(activityLabels) <- c('activityId','activityType')

# Merging all data in one set:
mrg_train <- cbind(y_train, subject_train, x_train)
mrg_test <- cbind(y_test, subject_test, x_test)
setAllInOne <- rbind(mrg_train, mrg_test)

# Extracting only the measurements on the mean and standard deviation for each measurement

# Reading column names:
colNames <- colnames(setAllInOne)

# Create vector for defining ID, mean and standard deviation:
mean_and_std <- (grepl("activityId" , colNames) | 
                   grepl("subjectId" , colNames) | 
                   grepl("mean.." , colNames) | 
                   grepl("std.." , colNames) 
)

# Making nessesary subset from setAllInOne:
setForMeanAndStd <- setAllInOne[ , mean_and_std == TRUE]

# Using descriptive activity names to name the activities in the data set:
setWithActivityNames <- merge(setForMeanAndStd, activityLabels,
                              by='activityId',
                              all.x=TRUE)

# Creating a second, independent tidy data set with the average of each variable for each activity and each subject:

secTidySet <- aggregate(. ~subjectId + activityId, setWithActivityNames, mean)
secTidySet <- secTidySet[order(secTidySet$subjectId, secTidySet$activityId),]
write.table(secTidySet, "TidySet.txt", row.name=FALSE)