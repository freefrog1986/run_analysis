# run_analysis.R is to clean and tidy dataset
# this is my approach：
# First include dplyr to use functions like select and merge summarise_all
# Second, preparing dataset by reading and binding all relevent data together 
# Third, setting property variable names and romeving duplicate column names
# fourth, Extracts only the measurements on the mean and standard deviation for each measurement
# sixth, getting average of each variable for each activity and each subject.
# Fifth, Merges the training and the test sets to create one data set
# last step, save result to mean_data.txt

# First include dplyr to use functions like select and merge summarise_all
library(dplyr)

# Second, preparing dataset by reading and binding all relevent data together 
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")

test_data <- cbind(y_test, subject_test, X_test)
train_data <- cbind(y_train, subject_train, X_train)

# Third, setting property variable names and romeving duplicate column names
features <- read.table("./UCI HAR Dataset/features.txt")
fea_names <- make.names(as.character(levels(features[,2]))[features[,2]])
colnames(test_data) <- c("label", "id", fea_names)
colnames(train_data) <- c("label", "id", fea_names)

#remove duplicate column names
test_data <- test_data[ , !duplicated(colnames(test_data))]
train_data <- train_data[ , !duplicated(colnames(train_data))]

# fourth, Extracts only the measurements on the mean and standard deviation for each measurement
ext_test_data <- select(test_data, matches("(mean|std)|id|label"))
ext_train_data <- select(train_data, matches("(mean|std)|id|label"))

# Fifth, Merges the training and the test sets to create one data set
merge_data <-merge(ext_test_data, ext_train_data , all = TRUE)

# sixth, getting average of each variable for each activity and each subject.
group_data <- group_by(merge_data,id,label)
mean_data <- summarise_all(group_data,.funs = mean)

# last step, save result to mean_data.txt
write.table(mean_data, file = "mean_data.txt", row.names = FALSE)
