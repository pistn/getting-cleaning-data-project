## read feature files
dataFeaturesTest<-read.table("X_test.txt",header=FALSE)
dataFeaturesTrain<-read.table("X_train.txt",header=FALSE)

## read subject files
dataSubjectTest<-read.table("subject_test.txt",header=FALSE)
dataSubjectTrain<-read.table("subject_train.txt",header=FALSE)

## read activity files
dataActivityTest<-read.table("Y_test.txt",header=FALSE)
dataActivityTrain<-read.table("Y_train.txt",header=FALSE)

##merge train and test data by rows
dataSubject <- rbind(dataSubjectTrain, dataSubjectTest)
dataActivity<- rbind(dataActivityTrain, dataActivityTest)
dataFeatures<- rbind(dataFeaturesTrain, dataFeaturesTest)

##set names to variables
names(dataSubject)<-c("subject")
names(dataActivity)<- c("activity")
dataFeaturesNames<-read.table("features.txt")
names(dataFeatures)<-dataFeaturesNames[,2]
head(dataActivity,3)

##merge columns to get the dataframe "data" for all data
dataCombine <- cbind(dataSubject, dataActivity)
Data <- cbind(dataFeatures, dataCombine)

##exctract only mean and standard deviation
subdataFeaturesNames<-dataFeaturesNames[grep("mean\\()|std\\()",dataFeaturesNames[,2]),2]
selectedNames<-c(as.character(subdataFeaturesNames), "subject", "activity" )
Data<-subset(Data,select=selectedNames)


##use descriptive activity names by factorizing activities in "Data" dataframe
activityLabels<-read.table("activity_labels.txt")
Data$activity<-factor(Data$activity,
               labels=as.character(activityLabels$V2))
                 

##descriptive names for the variables
names(Data)<-gsub("^t", "time", names(Data))
names(Data)<-gsub("^f", "frequency", names(Data))
names(Data)<-gsub("Acc", "Accelerometer", names(Data))
names(Data)<-gsub("Gyro", "Gyroscope", names(Data))
names(Data)<-gsub("Mag", "Magnitude", names(Data))
names(Data)<-gsub("BodyBody", "Body", names(Data))

##create a second, independent tidy data set with the average 
##of each variable for each activity and each subject.
DataFinal<-aggregate(formula=. ~subject + activity,data= Data,FUN= mean)
write.table(DataFinal, file = "tidydata.txt",row.name=FALSE,sep=",")

