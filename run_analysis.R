library(dplyr)

# Read all files to datasets
setwd("/Courses/Data Science/R/Ass3-Project/UCI HAR Dataset")
features_file <- ("features.txt")
activity_lbl_file <- ("activity_labels.txt")
subject_train_file <- ("./train/subject_train.txt")
X_train_file <- ("./train/X_train.txt")
Y_train_file <- ("./train/Y_train.txt")
subject_test_file <- ("./test/subject_test.txt")
X_test_file <- ("./test/X_test.txt")
Y_test_file <- ("./test/Y_test.txt")

features <- read.table(features_file)
activity_lbl <- read.table(activity_lbl_file)
subject_train <- read.table(subject_train_file)
X_train <- read.table(X_train_file)
Y_train <- read.table(Y_train_file)
subject_test <- read.table(subject_test_file)
X_test <- read.table(X_test_file)
Y_test <- read.table(Y_test_file)

# 1. Merges the training and the test sets to create one data set.
# combine all datasets
subject_all <- rbind(subject_test, subject_train)
X_all <- rbind(X_test, X_train)
Y_all <- rbind(Y_test, Y_train)

# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
col_num <- grep("mean|std", features$V2) #identify the row number matching mean or standard deviation. this will be used to select the columns in the dataset for mean/std
col_name <- grep("mean|std", features$V2, value = TRUE) #identify the row name matching mean or standard deviation. this will be used to name the column of the All dataset
X_all <- select(X_all,col_num)

# 3.Appropriately labels the data set with descriptive variable names. 
names(X_all) = col_name

# 4. Uses descriptive activity names to name the activities in the data set
X_all <- cbind(subject_all,Y_all, X_all)
names(X_all)[1:2] = c("Subject", "Activity")
#add new column "Activity_name" with the type of activities for each observation
#re-arrange the columns
X_all <- X_all %>% mutate(Activity_name = as.character(activity_lbl[Activity,2])) %>% select(Subject, Activity, Activity_name, everything())

# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
summary_avrg <- X_all %>% group_by(Subject, Activity_name) %>% summarize_all(funs(mean))