# Cleaning UCI Human Activity data

## Preparing the environment
**Importing the libraries**
We need to import the dplyr library in order to summarize the data at the end.

    library(dplyr)

**Downloading the data**
We start by downloading the zipped data file if it does not exist. Then we unzip the data in the current folder.

    if(!file.exists("UCI HAR Dataset.zip"))
	    download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", destfile = "./UCI HAR Dataset.zip")
    unzip("UCI HAR Dataset.zip")

## Loading the data
**Loading training data**
We first need to load the training data set [train_X], labels [train_activity], and subject identifiers [train_subject]. Then we merge the columns together.

    train_subject <- read.csv("./UCI HAR Dataset/train/subject_train.txt", header = F, sep = " ")
    train_X <- read.table("./UCI HAR Dataset/train/X_train.txt")
    train_activity <- read.csv("./UCI HAR Dataset/train/y_train.txt", header = F, sep = " ")

    train <- cbind(train_subject, train_X, train_activity)
**Loading testing data**
We first need to load the testing data set [test_X], labels [test_activity], and subject identifiers [test_subject]. Then we merge the columns together.

    test_subject <- read.csv("./UCI HAR Dataset/test/subject_test.txt", header = F, sep = " ")
    test_X <- read.table("./UCI HAR Dataset/test/X_test.txt")
    test_activity <- read.csv("./UCI HAR Dataset/test/y_test.txt", header = F, sep = " ")

    test <- cbind(test_subject, test_X, test_activity)
Merging the training and testing data records

    dataset <- rbind(train, test)

## Loading and manipulating names and features
**Loading activity names**
We start by loading the activity names [activity_names]. Then we replace every activity ID in the *dataset* (from 1 to 6) with the corresponding activity name.

    activity_names <- read.table('./UCI HAR Dataset/activity_labels.txt', header = FALSE)
    activity_names <- activity_names[, 2]
    dataset[,dim(dataset)[2]] <- activity_names[dataset[,dim(dataset)[2]]]
**Loading feature names**
We first load the feature names [features]. Then we select the features containing "mean" and "std" (for mean and standard deviation.)

    features <- read.csv("./UCI HAR Dataset/features.txt", header = F, sep = " ")
    features <- features[, 2]
    selected_features <- sort(c(grep("mean", features), grep("std", features)))
    features <- features[selected_features]
**Manipulating feature names**
We apply the following modifications (by order) on feature names to make them descriptive:

 - Substituting every starting "t" with "TimeDomain_"
 - Substituting every starting "f" with "FrequencyDomain_"
 - Substituting every "Acc" with "Accelerometer"
 - Substituting every "Gyro" with "Gyroscope"
 - Substituting every "Mag" with "Magnitude"
 - Substituting every "mean" with "Mean"
 - Substituting every "MeanFreq" with "MeanFrequency"
 - Substituting every "std" with "StandardDeviation"
 - Substituting every dash "-" with underscore "_"
 - Substituting every parentheses "()" with empty text to remove them

**Code:**

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
## Preparing the final, tidy dataset
**Extracting specific variable**
We extract only variables (columns) with features names "mean" and "std" as mentioned above, in addition to the Activity and Subject columns. Then we add the feature names to the dataset.

    dataset <- dataset[, c(1, selected_features, dim(dataset)[2])]
    names(dataset) <- c("Subject", features, "Activity")
**Preparing another dataset with average values**
We group the tidy dataset [dataset] by the *Subject* and *Activity* variables. Then we summarize all the columns of the grouped dataset by applying the function *mean* on all the columns for each Subject and Activity. We store the new dataset in the variable [avg_dataset]

    avg_dataset <- dataset %>%
	    group_by(Subject, Activity) %>%
	    summarize_all(funs(mean))

We can alse save the new dataset in a new file.

    enter code here

