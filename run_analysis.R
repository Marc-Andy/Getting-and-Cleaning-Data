
## DOWNLOAD AND UNZIP DATA

if(!file.exists("./data")){dir.create("./data")}
fileurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileurl,destfile="./data/Dataset.zip")

unzip(zipfile="./data/Dataset.zip",exdir="./data")

## READ DATA
x_train <- read.table("./data/UCI HAR Dataset/train/x_train.txt")
y_train <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
sub_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")

x_test <- read.table("./data/UCI HAR Dataset/test/x_test.txt")
y_test <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
sub_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")

features <- read.table("./data/UCI HAR Dataset/features.txt")
activity_label <- read.table("./data/UCI HAR Dataset/activity_labels.txt")

## 1. Merges the training and the test sets to create one data set.

x_dat <- rbind(x_train, x_test)
y_dat <- rbind(y_train, y_test)
sub_dat <- rbind(sub_train, sub_test)

## ASSIGNING COLUMN NAMES
colnames(x_dat) <- feat[,2]
colnames(y_dat) <- "activityID"
colnames(sub_dat) <- "subjectID"

one_dataset <- cbind(sub_dat, y_dat, x_dat)

## 2. Extracts only the measurements on the mean and standard deviation for each measurement.

colname_one <- colnames(one_dataset)

mean_std <- (grepl("subjectID", colname_one) |
                   grepl("activityID", colname_one) |
                   grepl("mean..", colname_one) |
                   grepl("std..", colname_one))

mean_std_subset <- one_dataset[, mean_std]


## 3. Uses descriptive activity names to name the activities in the data set

colnames(activity_label) <- c("activityID","activity")

data <- merge(mean_std_subset, activity_label, by = "activityID", all.x=TRUE, sep =  "  ")

## 4. Appropriately labels the data set with descriptive variable names.

names(data) <- gsub("[\\(\\)]", "", names(data))
names(data) <- gsub("^f", "Frequency", names(data))
names(data)<- gsub("^t", "Time", names(data))
names(data)<- gsub("Acc", "Accelerometer", names(data))
names(data)<- gsub("Gyro", "Gyroscope", names(data))
names(data)<- gsub("Mag", "Magnitude", names(data))
names(data)<- gsub("mean", "Mean", names(data))
names(data) <- gsub("std", "StandadDeviation", names(data))
names(data) <- gsub("BodyBody", "Body", names(data))
names(data) <- gsub("-MeanFreq", "-MeanFrequency", names(data))

## 5. From the data set in step 4, creates a second, independent tidy data set with the average 
## of each variable for each activity and each subject.

tidydata <- aggregate(. ~subjectID + activityID + activity, data, mean)

## Put ID and activity in the right order 
tidydata <- tidydata[order(tidydata$subjectID, tidydata$activityID, tidydata$activity), ]

## write tidydata in a text file
write.table(tidydata, file = "tidydata.txt", row.names = FALSE, quote = FALSE)

## THE END
