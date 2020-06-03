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