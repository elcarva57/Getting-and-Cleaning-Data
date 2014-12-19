Explanation for Getting and Cleaning Data course project
--------------------------------------------------------

These are instructions to run R script `run_analysis.R`

**IMPORTANT**
When extracting the Samsung data zip file: `UCI HAR Dataset.zip`
it creates a folder named: `UCI HAR Dataset`
and under this folder there are two more folders: `train` and `test`
In these folders there are the files needed to run this script:
```
./features.txt
./train/subject_train.txt
./train/X_train.txt
./train/y_train.txt
./test/subject_test.txt
./test/X_test.txt
./test/y_test.txt
```

Please put this script in `UCI HAR Dataset` folder and set the working
directory there to run properly: `setwd("your_path/UCI HAR Dataset")`

Thank you!

This script performs the five points required:

- 1. Merges the training and the test sets to create one data set.
- 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
- 3. Uses descriptive activity names to name the activities in the data set
- 4. Appropriately labels the data set with descriptive variable names. 
- 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

First we get the train data from folder train, using read.csv
```
dataXtrain<-read.csv("./train/X_train.txt",sep="",header=FALSE,stringsAsFactors=FALSE,fill=FALSE)
```
Then we get the test data from folder test
```
dataXtest<-read.csv("./test/X_test.txt",sep="",header=FALSE,stringsAsFactors=FALSE,fill=FALSE)
```
And we merge both datasets into a new one. This is point 1  
**1. Merges the training and the test sets to create one data set.**
```
dataX<-rbind(dataXtrain,dataXtest)
```
Read features (column names) from file `features.txt` in actual folder
```
features<-read.csv("features.txt",sep=" ",header=FALSE,stringsAsFactors=FALSE)
```
In features data.table, column 2 is the feature name (column 1 is the code)
```
names(features)[2]<-c("feature")
```
I have added and assigned the column names to the dataset, from this step on. So this is point 4  
**4. Appropriately labels the data set with descriptive variable names.**
```
names(dataX)<-features$feature
```
Extracts only columns containing exactly "mean()"
```
dmean<-dataX[,grep("mean\\(\\)",colnames(dataX))]
```
Extracts only columns containing exactly "std()"
```
dstd<-dataX[,grep("std\\(\\)",colnames(dataX))]
```
Overwrites data with the join of mean dataset and standard deviation dataset. This is point 2  
**2. Extracts only the measurements on the mean and standard deviation for each measurement.**
```
dataX<-cbind(dmean,dstd)
```
Now, we get train activities from folder train, using read.csv
```
dataYtrain<-read.csv("./train/y_train.txt",header=FALSE)
```
And train subjects from folder train
```
dataStrain<-read.csv("./train/subject_train.txt",header=FALSE)
```
Then test activities from folder test
```
dataYtest<-read.csv("./test/y_test.txt",header=FALSE)
```
And test subjects from folder test
```
dataStest<-read.csv("./test/subject_test.txt",header=FALSE)
```
We create activities desciptive names
```
activities<-c("WALKING","WALKING_UP","WALKING_DOWN","SITTING","STANDING","LAYING")
```
We merge activities (Y values) from training and test sets.
```
dataY<-rbind(dataYtrain,dataYtest)
```
We merge subjects (S values) from training and test sets.
```
dataS<-rbind(dataStrain,dataStest)
```
Rename column 1 from activities data set to "code"
```
names(dataY)[1]<-c("code")
```
Rename column 1 from subjects data set to "subject"
```
names(dataS)[1]<-c("subject")
```
Create column "activity" with descriptive names. This is point 3  
**3. Uses descriptive activity names to name the activities in the data set**
```
dataY$activity<-activities[dataY$code]
```
We create `data` dataset adding subjects column, activity column and data
```
data<-cbind(dataS,dataY["activity"],dataX)
```
From data we obtain the average of all variables grouping by subject and activity  
Two first columns (subject and activity) are excluded from data (data[,3:68])
because they are used to group the rest of variables. This is point 5  
**5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.**
```
tidyData<-aggregate(data[,3:68], by=list(SUBJECT=data$subject, ACTIVITY= data$activity), FUN=mean)
```
Output

Display the structure of final tidy data set, because the original is too big
```
str(tidyData)
```
Display the final tidy data set in the source pannel
```
View(tidyData)
```