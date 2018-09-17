library(reshape2)

#merging the test and train datasets
#load the train dataset
train_subject <- read.table("C:/Users/kaumi/Documents/MOOC Courses/Coursera/Data_Science_Specialisation/Getting and Cleaning Data/dataset/train/subject_train.txt")
test_subject <- read.table("C:/Users/kaumi/Documents/MOOC Courses/Coursera/Data_Science_Specialisation/Getting and Cleaning Data/dataset/test/subject_test.txt")
xtrain <- read.table("C:/Users/kaumi/Documents/MOOC Courses/Coursera/Data_Science_Specialisation/Getting and Cleaning Data/dataset/train/X_train.txt")
ytrain <- read.table("C:/Users/kaumi/Documents/MOOC Courses/Coursera/Data_Science_Specialisation/Getting and Cleaning Data/dataset/train/y_train.txt")
xtest <- read.table("C:/Users/kaumi/Documents/MOOC Courses/Coursera/Data_Science_Specialisation/Getting and Cleaning Data/dataset/test/X_test.txt")
ytest <- read.table("C:/Users/kaumi/Documents/MOOC Courses/Coursera/Data_Science_Specialisation/Getting and Cleaning Data/dataset/test/y_test.txt")

#merging X,y and subject data
x <- rbind(xtrain,xtest)
y <- rbind(ytrain,ytest)
subject <- rbind(train_subject,test_subject)

#read the feature description
features <- read.table("C:/Users/kaumi/Documents/MOOC Courses/Coursera/Data_Science_Specialisation/Getting and Cleaning Data/dataset/features.txt")
features <- features[,"V2"]

#set descriptive names for all columns in merged X,y and subject data
colnames(x) <- features
colnames(y) <- "activity_id"
colnames(subject) <- "subject"

#select features containing measurements on the mean and standard deviation
means <- grep("-mean\\(\\)",features,value=TRUE)
stds <- grep("-std\\(\\)",features,value=TRUE)
exfeatures <- c(means,stds)
x2 <- x[,exfeatures]
#extracted all the mean and std features of x into x2

#read in activity descriptions
activities <- read.table("C:/Users/kaumi/Documents/MOOC Courses/Coursera/Data_Science_Specialisation/Getting and Cleaning Data/dataset/activity_labels.txt")
colnames(activities) <- c("activity_id","activity")

#merging the target labels with the activity dataset
y2 <- merge(y,activities)

#join measurements dataset with activity labels
data <- cbind(x2,y2["activity"])

#writing the data result to csv
write.csv(data,"measurements.txt")

#combining the data to the subject
data2 <- cbind(data,subject)

#summarize mean per unique pair
data2melt <- melt(data2,id=c("subject","activity"))
data3 <- dcast(data2melt,activity+subject ~ variable,mean)

#writing it to csv
write.csv(data3,"activity_means.csv")
