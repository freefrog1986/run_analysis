#### include relevent packages and remove all environment variables
library(dplyr)
library(data.table)
rm(list = ls())

#### Set the working directory; modify this to accommodate your local environment.
setwd("/Users/freefrog/coding/datascience/gitrepo/run_analysis")

#### As of 1/5/2017, this was the URL for obtaining the Samsung dataset which we will make tidy
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
localfile <- file.path(getwd(), "Dataset.zip")
download.file(url, localfile)
unzip(localfile)

## 1. Merges the training and the test sets to create one data set.
#### loda files into R as tables
x_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
x_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
features <- read.table("./UCI HAR Dataset/features.txt")
activities <- read.table("./UCI HAR Dataset//activity_labels.txt")

#### Combain the relevent testing and training data
all_data <- rbind(x_train , x_test)
all_labels <- rbind(y_train,y_test)
all_subjects <- rbind(subject_train,subject_test)

## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
#### First find the columns that contain 'mean(' an 'std(' names within them
mean_features <- grep("mean\\(", features[, 2])
std_features <- grep("std\\(", features[, 2])
all_features <- sort(c(mean_features,std_features))

##### create a new table 'data' that contains a subset of columns with std and mean functions  
data <- all_data[,all_features]
names(data) <- tolower(features[all_features,2])
all_labels[,1] <- activities[all_labels[,1], 2]

## 3. Uses descriptive activity names to name the activities in the data set
##### Name the 'labels' table as 'Activities, and 'subjects' as 'Subject'
names(all_labels) <- "Activities"
names(all_subjects) <- "Subject"

## 4. Appropriately labels the data set with descriptive variable names.
##### Export the combined tidy dataset. 
tidy_data <- cbind(all_subjects, all_labels, data)
write.csv(tidy_data,"tidy_data.csv")

## 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
group_data <- group_by(tidy_data,Subject,Activities)
mean_data <- summarise_all(group_data,.funs = mean)
write.table(mean_data, file = "mean_data.txt", row.names = FALSE)

