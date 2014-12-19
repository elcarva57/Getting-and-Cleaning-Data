# ============================ IMPORTANT =======================================
# When extracting the Samsung data zip file: "UCI HAR Dataset.zip"
# it creates a folder named: "UCI HAR Dataset"
# and under this folder there are two more folders: train and test
# In these folders there are the files needed to run this script:
#
# ./features.txt
# ./train/subject_train.txt
# ./train/X_train.txt
# ./train/y_train.txt
# ./test/subject_test.txt
# ./test/X_test.txt
# ./test/y_test.txt
#
# Please put this script in "UCI HAR Dataset" folder and set the working
# directory there to run properly: setwd("your_path/UCI HAR Dataset")
# Thank you!
#===============================================================================

# Get train data
dataXtrain<-read.csv("./train/X_train.txt",sep="",header=FALSE,stringsAsFactors=FALSE,fill=FALSE)

# Get test data
dataXtest<-read.csv("./test/X_test.txt",sep="",header=FALSE,stringsAsFactors=FALSE,fill=FALSE)

#===============================================================================
# 1. Merges the training and the test sets to create one data set.
#===============================================================================
dataX<-rbind(dataXtrain,dataXtest)

# Read features (column names)
features<-read.csv("features.txt",sep=" ",header=FALSE,stringsAsFactors=FALSE)

# Column 2 is the feature name
names(features)[2]<-c("feature")

#===============================================================================
# 4. Appropriately labels the data set with descriptive variable names. 
#===============================================================================
# I have added the column names from this step on
# Assigns column names to dataset
names(dataX)<-features$feature

# Extracts columns containing exactly "mean()"
dmean<-dataX[,grep("mean\\(\\)",colnames(dataX))]

# Extracts columns containing exactly "std()"
dstd<-dataX[,grep("std\\(\\)",colnames(dataX))]

#===============================================================================
# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
#===============================================================================
# Overwrites data with the join of mean dataset and standard deviation dataset
dataX<-cbind(dmean,dstd)

# Get train activities
dataYtrain<-read.csv("./train/y_train.txt",header=FALSE)

# Get train subjects
dataStrain<-read.csv("./train/subject_train.txt",header=FALSE)

# Get test activities
dataYtest<-read.csv("./test/y_test.txt",header=FALSE)

# Get test subjects
dataStest<-read.csv("./test/subject_test.txt",header=FALSE)

# Activities desciptive names
activities<-c("WALKING","WALKING_UP","WALKING_DOWN","SITTING","STANDING","LAYING")

# Merges Y values (activities) form training and test sets.
dataY<-rbind(dataYtrain,dataYtest)

# Merges S values (subjects) form training and test sets.
dataS<-rbind(dataStrain,dataStest)

# Rename column 1 from activities data set to "code"
names(dataY)[1]<-c("code")

# Rename column 1 from subjects data set to "subject"
names(dataS)[1]<-c("subject")

#===============================================================================
# 3. Uses descriptive activity names to name the activities in the data set
#===============================================================================
# Create column "activity" with descriptive names
dataY$activity<-activities[dataY$code]

# Create data dataset adding subjects column, activity column and data
data<-cbind(dataS,dataY["activity"],dataX)

#===============================================================================
# 5. From the data set in step 4, creates a second, independent tidy data set with 
#    the average of each variable for each activity and each subject.
#===============================================================================
# From data we obtain the average of all variables grouping by subject and activity
# Two first columns (subject and activity) are excluded from data (data[,3:68])
# because they are used to group the rest of variables.
tidyData<-aggregate(data[,3:68], by=list(SUBJECT=data$subject, ACTIVITY= data$activity), FUN=mean)

# Output

# Display the structure of final tidy data set, because the original is too big
str(tidyData)

# Display the final tidy data set in the source pannel
View(tidyData)