library(dplyr)

#load dataset
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")

#gets the test_data and train_data
test_data <- cbind(y_test, subject_test, X_test)
train_data <- cbind(y_train, subject_train, X_train)

#set variable names
features <- read.table("./UCI HAR Dataset/features.txt")
fea_names <- make.names(as.character(levels(features[,2]))[features[,2]])
colnames(test_data) <- c("label", "id", fea_names)
colnames(train_data) <- c("label", "id", fea_names)

#remove duplicate columm names
test_data <- test_data[ , !duplicated(colnames(test_data))]
train_data <- train_data[ , !duplicated(colnames(train_data))]

#Extracts only the measurements on the mean and standard deviation for each measurement
ext_test_data <- select(test_data, matches("(mean|std)|id|label"))
ext_train_data <- select(train_data, matches("(mean|std)|id|label"))

#Merges the training and the test sets to create one data set
merge_data <-merge(ext_test_data, ext_train_data , all = TRUE)

#getting average of each variable for each activity and each subject.
group_data <- group_by(merge_data,id,label)
mean_data <- summarise_all(group_data,.funs = mean)

#save result to mean_data.txt
write.table(mean_data, file = "mean_data.txt", row.names = FALSE)
