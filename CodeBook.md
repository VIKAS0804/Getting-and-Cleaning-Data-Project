#get the library for reading text files
read in labels to be used later for adding description to variables and observations

 read in activity labels
activity_labels

read in feture list
feature_list



#  Read In test data


read in the file that contains id's of subjects per observation
test_subjects

read in the main features file for test data
test_dataset

read in the activities for test_data
test_activities

bind the test data set per observations
testset

Add descriptive activity names to the activities in the test data set
final_testset

# 3. Read In training data

read in the file that contains id's of subjects per observation
train_subjects

read in the main features file for test data
train_dataset

read in the activities for train_data
train_activities

bind the train data set per observations
trainset

Add descriptive activity names to the activities in the train data set
final_trainset

# 4. Merge test and train dataset

data<-merge(final_testset,final_trainset,all=TRUE)

create a tidy dataset

load the library for reshaping data

First we melt the data set in order to produce a casted table on multiple columns later on.
we melt the data set on all value conserving as ids (Subject.Id and Activity)

take the column names which will be aggregated
average_columns

melt the data
melted_data

now cast the melted data set to produce the tidy dataset
tidy_dataset

print the tidy data
tidy_dataset


code for the above variables and explanation

library(data.table)
activity_labels<-read.table("UCI HAR Dataset/activity_labels.txt")
names(activity_labels)<-c("Activity.Id","Activity")
feature_list<-read.table("UCI HAR Dataset/features.txt")
test_subjects<-read.table("UCI HAR Dataset/test/subject_test.txt")
names(test_subjects)<-"Subject.Id"
test_dataset<-read.table("UCI HAR Dataset/test/X_test.txt")
names(test_dataset)<-feature_list$V2
test_activities<-read.table("UCI HAR Dataset/test/Y_test.txt")
names(test_activities)<-"Activity.Id"
testset<-cbind(test_subjects,test_dataset,test_activities)
sliced_testset <<- testset[,grepl("Subject.Id|Activity.Id|mean\\(\\)|std\\(\\)",colnames(testset))]
final_testset<-merge(sliced_testset,activity_labels,all=TRUE)
train_subjects<-read.table("UCI HAR Dataset/train/subject_train.txt")
names(train_subjects)<-"Subject.Id"
train_dataset<-read.table("UCI HAR Dataset/train/X_train.txt")
names(train_dataset)<-feature_list$V2
train_activities<-read.table("UCI HAR Dataset/train/Y_train.txt")
names(train_activities)<-"Activity.Id"
trainset<-cbind(train_subjects,train_dataset,train_activities)
sliced_trainset <<- trainset[,grepl("Subject.Id|Activity.Id|mean\\(\\)|std\\(\\)",colnames(trainset))]
final_trainset<-merge(sliced_trainset,activity_labels,all=TRUE)
data<-merge(final_testset,final_trainset,all=TRUE)
library(reshape2)
average_columns<-colnames(data[,3:68])
melted_data<- melt(data,id=c("Subject.Id","Activity"),measure.vars=average_columns)
tidy_dataset <- dcast(melted_data, Subject.Id + Activity ~ variable, mean)
write.table(tidy_dataset, file = "tidydataset.txt", row.names= FALSE)
