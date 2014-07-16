run_analysis.R does the following. 
It assumes the working directory has 2 folders (Train and Test) and takes in 3 files from each of those (X, Y and Subject)
It takes in an Activity file and Features file from the working directory.


After that it calls the column in Subject, "Subject" - these will be numbers of the subjects from 1 to 30
It calls the columns in the Y files to be Activity and then uses a match on the Activity data
to replace each element in the Y files with the actual name of the Activity.

It does a similar thing with the features data and X data to replace column names with the codes used in Features. 

It looks for std or mean in these column names to filter out the variables we're interested in. 
I also add a column to denote whether its Test or Train data but this seems to have been unnecessary.

Once we have filtered out the columns we are interested in, we combine the Test and Train files for subject, X and Y. Then we c bind the result.

With this FullData, we need to make the variable names more sensible. So, the DescriptiveMatrix creates a list of changes that we can make.
And the For loop executes those.

With the sensibly named data, we use an aggregate function inside a with function to get the average values of the numeric columns
for each subject and activity.

Then we call this the TidyData and write it.
Merges the training and the test sets to create one data set.
Extracts only the measurements on the mean and standard deviation for each measurement. 
Uses descriptive activity names to name the activities in the data set
Appropriately labels the data set with descriptive variable names. 
Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 
