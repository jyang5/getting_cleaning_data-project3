test_data<-read.table("./UCI HAR Dataset/test/X_test.txt")
train_data<-read.table("./UCI HAR Dataset/train/X_train.txt")

test_label<-read.table("./UCI HAR Dataset/test/y_test.txt")
train_label<-read.table("./UCI HAR Dataset/train/y_train.txt")

test_subject<-read.table("./UCI HAR Dataset/test/subject_test.txt")
train_subject<-read.table("./UCI HAR Dataset/train/subject_train.txt")

merged_data<-rbind(train_data,test_data)
merged_label<-rbind(train_label,test_label)
merged_subject<-rbind(train_subject,test_subject)

names(merged_subject)<-"subject"
names(merged_label)<-"label"

features<-read.table("./UCI HAR Dataset/features.txt")
names(merged_data)<-features$V2

#step1: Merges the training and the test sets to create one data set.
data_set1<-cbind(merged_subject,merged_label)
data_set<-cbind(merged_data,data_set1)

#step2: Extracts only the measurements on the mean and standard deviation for each measurement. 
mean_std_feature<-grep("mean\\(\\)|std\\(\\)", features$V2)
columns<-c(as.character(features$V2[mean_std_feature]), "subject", "label" )
data_set<-subset(data_set, select = columns)

#step3: Uses descriptive activity names to name the activities in the data set
activityLabels  <- read.table("./UCI HAR Dataset/activity_labels.txt")
data_set$label<-factor(data_set$label,activityLabels$V1, activityLabels$V2)

#step4: Appropriately labels the data set with descriptive variable names. 
names(data_set)<-gsub("^t", "time", names(data_set))
names(data_set)<-gsub("^f", "frequency", names(data_set))
names(data_set)<-gsub("Acc", "Accelerometer", names(data_set))
names(data_set)<-gsub("Gyro", "Gyroscope", names(data_set))
names(data_set)<-gsub("Mag", "Magnitude", names(data_set))
names(data_set)<-gsub("BodyBody", "Body", names(data_set))

#step5: From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
library(plyr)
data_set2<-aggregate(. ~subject + label, data_set, mean)
data_set2<-data_set2[order(data_set2$subject,data_set2$label),]
write.table(data_set2, file = "tidydata.txt",row.name=FALSE)
