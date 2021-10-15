library(dplyr)
# Dwonloading and extracting data
#if(!file.exists("UCI HAR Dataset.zip"))
#  download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", destfile = "./UCI HAR Dataset.zip")
#unzip("UCI HAR Dataset.zip")

# Loading and merging train data
train_subject <- read.csv("./UCI HAR Dataset/train/subject_train.txt", header = F, sep = " ")
train_X <- read.table("./UCI HAR Dataset/train/X_train.txt")
train_activity <- read.csv("./UCI HAR Dataset/train/y_train.txt", header = F, sep = " ")

train <- cbind(train_subject, train_X, train_activity)

# Loading and merging test data
test_subject <- read.csv("./UCI HAR Dataset/test/subject_test.txt", header = F, sep = " ")
test_X <- read.table("./UCI HAR Dataset/test/X_test.txt")
test_activity <- read.csv("./UCI HAR Dataset/test/y_test.txt", header = F, sep = " ")

test <- cbind(test_subject, test_X, test_activity)

# Merging train and test data together
dataset <- rbind(train, test)

# Using activity names
activity_names <- read.table('./UCI HAR Dataset/activity_labels.txt', header = FALSE)
activity_names <- activity_names[, 2]
dataset[,dim(dataset)[2]] <- activity_names[dataset[,dim(dataset)[2]]]

# Loading feature names, filtering, and cleaning them
features <- read.csv("./UCI HAR Dataset/features.txt", header = F, sep = " ")
features <- features[, 2]
selected_features <- sort(c(grep("mean", features), grep("std", features)))
features <- features[selected_features]

features <- gsub("^t", "TimeDomain_", features)
features <- gsub("^f", "FrequencyDomain_", features)
features <- gsub("Acc", "Accelerometer", features)
features <- gsub("Gyro", "Gyroscope", features)
features <- gsub("Mag", "Magnitude", features)
features <- gsub("mean", "Mean", features)
features <- gsub("MeanFreq", "MeanFrequency", features)
features <- gsub("std", "StandardDeviation", features)
features <- gsub("-", "_", features)
features <- gsub("[()]", "", features)


# Extracting mean and std data
dataset <- dataset[, c(1, selected_features, dim(dataset)[2])]

# Adding feature names to the dataset
names(dataset) <- c("Subject", features, "Activity")

# Average of each variable for each activity and subject
avg_dataset <- dataset %>%
                group_by(Subject, Activity) %>%
                summarize_all(funs(mean))
# Saving the average dataset in a new file avg_dataset.txt
write.table(x = avg_dataset, file = "avg_dataset.txt", row.names = FALSE)

#avg_dataset
