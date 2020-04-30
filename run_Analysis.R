library(reshape2)

setwd("E:/R/UCI HAR Dataset")
train_x <- read.table("E:/R/UCI HAR Dataset/train/X_train.txt")
train_y <- read.table("E:/R/UCI HAR Dataset/train/Y_train.txt")
train_subject <- read.table("E:/R/UCI HAR Dataset/train/subject_train.txt")
train <- cbind(train_subject, train_y, train_x)


test_x <- read.table("E:/R/UCI HAR Dataset/test/X_test.txt")
test_y <- read.table("E:/R/UCI HAR Dataset/test/Y_test.txt")
test_subject <- read.table("E:/R/UCI HAR Dataset/test/subject_test.txt")
test <- cbind(test_subject, test_y, test_x)

activity_labels <- read.csv("E:/R/UCI HAR Dataset/activity_labels.txt", sep="", header=FALSE)
activity_labels[,2] <- as.character(activity_labels[,2])
features <- read.csv("E:/R/UCI HAR Dataset/features.txt", sep="", header=FALSE)

measurements_rows <- grep(".*mean.*|.*std.*", features[,2])
measurements <- features[measurements_rows,2]
measurements = gsub('-mean', 'Mean', measurements)
measurements = gsub('-std', 'Std', measurements)
measurements <- gsub('[-()]', '', measurements)



joint_data <- rbind(train, test)
colnames(joint_data) <- c("subject", "activity", measurements)


joint_data$activity <- factor(joint_data$activity, levels = activity_labels[,1], labels = activity_labels[,2])
joint_data$subject <- as.factor(joint_data$subject)

melt_data <- melt(joint_data, id = c("subject", "activity"))
mean_data <- dcast(melt_data, subject + activity ~ variable, mean)

write.table(mean_data, "tidy_data.txt", row.names = FALSE, quote = FALSE)



