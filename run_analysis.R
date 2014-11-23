install.packages(c('data.table', 'reshape2', 'plyr'))

library('data.table')
library('plyr')
library('reshape2')

## PART 1
base_dir <- '/home/urbandev/UCI\ HAR\ Dataset/'

# read data from test set.
test_set_file_path <- paste(base_dir, 'test/X_test.txt', sep = '', collapse = NULL)
test_set <- read.table(test_set_file_path)
test_labels_file_path <- paste(base_dir, 'test/y_test.txt', sep = '', collapse = NULL)
test_labels <- read.table(test_labels_file_path, col.names="label")
test_subjects_file_path <- paste(base_dir, 'test/subject_test.txt', sep = '', collapse = NULL)
test_subjects <- read.table(test_subjects_file_path, col.names="subject")

# read data from training set.
training_set_file_path <- paste(base_dir, 'train/X_train.txt', sep = '', collapse = NULL)
training_set <- read.table(training_set_file_path)
training_labels_file_path <- paste(base_dir, 'train/y_test.txt', sep = '', collapse = NULL)
training_labels <- read.table(training_labels_file_path, col.names="label")
training_subjects_file_path <- paste(base_dir, 'train/subject_test.txt', sep = '', collapse = NULL)
training_subjects <- read.table(training_subjects_file_path, col.names="subject")

# merge data from test set and training set.
merged_test_training_data <- rbind(cbind(test_subjects, test_labels, test_data),
                                   cbind(training_subjects, training_labels, training_data))

## PART 2
# mean and standrad deviation are estimated from the signals provided in the features.
# we need to parse all features and keep only mean and standard deviation.
features_file_path <- paste(base_dir, 'features.txt', sep = '', collapse = NULL)
all_features <- read.table(features_file_path, strip.white=TRUE, stringsAsFactors=FALSE)

#mean_std_dev_info <- all_features[grep("mean\\(\\)|std\\(\\)", all_features$V2), ]

mean_features <- all_features[grep("mean\\(\\)", all_features$V2), ]
mean_data <- merged_test_training_data[, c(1, 2, mean_features$V1+2)]

std_dev_features <- all_features[grep("std\\(\\)", all_features$V2), ]
std_dev_data <- merged_test_training_data[, c(1, 2, std_dev_features$V1+2)]

## PART 3
# Map activity_labels to the data set
activity_labels_file_path <- paste(base_dir, 'activity_labels.txt', sep = '', collapse = NULL)
all_activity_labels = read.table(activity_labels_file_path, , stringsAsFactors=FALSE)
#mean_std_dev_info$activity_label = factor(mean_std_dev_info$activity, levels = available_levels, labels = all_activity_labels$V2)
mean_data$label <- all_activity_labels[mean_data$label, 2]
std_dev_data$label <- all_activity_labels[std_dev_data$label, 2]

## PART 4
# labeling the data with descriptive variable names
