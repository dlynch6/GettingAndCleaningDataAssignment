
#First, lets read in all the data. This assumes that there's a 'test' folder and a 'train' folder 
#in the Working Directory.
#Each Directory has 3 files, "X_"+folder, "Y_"+folder and "Subject"+folder.
XTest <- read.table("./test/X_test.txt", as.is=T)
YTest <- read.table("./test/y_test.txt", as.is=T)
SubjectTest <- read.table("./test/subject_test.txt", as.is=T)
XTrain <- read.table("./train/x_train.txt", as.is=T)
YTrain <- read.table("./train/y_train.txt", as.is=T)
SubjectTrain <- read.table("./train/subject_train.txt", as.is=T)

#Now let's read in the activities and features files from the Working Directory
activities <- read.table("activity_labels.txt", as.is=T)
features <- read.table("features.txt", as.is=T)


#And, I'm going to rename the columns of X to be the Descriptions from 'Features'
#I'll get the row names in 'features' to match the column names in the X data at this point by adding a "V"
features[,"V1"] <- paste("V", features[,"V1"], sep = "")
colnames(XTest) <- features[match(colnames(XTest), features[,"V1"]),"V2"]
colnames(XTrain) <- features[match(colnames(XTrain), features[,"V1"]),"V2"]

#I'm going to make some name changes to column names at this point so that the 
#Y and Subject columns become a bit more intuitive.
colnames(YTest) <- "Activity"
colnames(YTrain)  <- "Activity"
colnames(SubjectTest) <- "Subject"
colnames(SubjectTrain) <- "Subject"


#I don't want to lose sight of whether the data is Test or Train once they're merged 
#so I'm adding it as a column.
XTest["TestOrTrain"] <- "Test"
XTrain["TestOrTrain"] <- "Train"

#This creates the merged Train and Test versions of X
X <- rbind(XTest,XTrain)

#And this filters it to just the variables we're interested in, i.e. ones with 'mean' and 'std' in them.
FilterX <- colnames(X)[grep("mean|std|TestOrTrain",colnames(X))]
XFilteredForMeanAndStd <- X[,FilterX]


#Now let's bind the Y data
Y <- rbind(YTest,YTrain)

#And the Subject data
Subject <- rbind(SubjectTest,SubjectTrain)

#But before adding it to 'X' to create the full set. Let's make the activities descriptive.
#This gives the Activity name from the number supplied
Y[,"Activity"] <- activities[match(Y[,"Activity"],activities[,"V1"]),2]

#And, voila. The Full Data
FullData <- cbind(Subject, Y, XFilteredForMeanAndStd)

#Now, we already have decriptive Activity names. Next, I want to make the column names more Descriptive.
#So, let's create a matrix of all the changes I would make.
DescriptiveMatrix <- matrix(c("Gyro", "Acc", "tBody", "Mag", "mean", "std","Freq","X","Y","Z","\\()","-",
                              "fBody","tGravity",
                              "Velocity", "Acceleration", "TimeSignalsBody", "Magnitude", "Average", 
                              "StandardDeviation", "Frequency","AlongXAxis",
                              "AlongYAxis","AlongZAxis","","","FrequencySignalsBody","TimeSignalsGravity"), ncol = 2)

NameX <- colnames(FullData)
#This for loop will substitute each element of column1 in the above matrix
#with the appropriate entry from column2. Then we can rename the columns of FullData with the result.
for (i in seq_along(DescriptiveMatrix[,1])) {
        NameX <- gsub(DescriptiveMatrix[i,1], DescriptiveMatrix[i,2], NameX)
}
colnames(FullData) <- NameX




#Next, for every combination of subject(30) and activity(6) we want the average of each column
# - that will be 30 x 6 = 180 rows. We can achieve this with the Aggregate function.
TidyData <- with(FullData, aggregate(FullData[,3:81],list(Subject=Subject, Activity = Activity),mean ))

#And finally, write this table so I can upload to Coursera
write.table(TidyData, file = "TidyData.txt")
