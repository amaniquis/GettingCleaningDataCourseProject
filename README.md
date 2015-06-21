###Requirements
System specifications under which the run_analysis.R script was developed, tested, and run:
* Mac OS X 10.10.3
* R 3.1.3
* RStudio 0.98.1103

The included run_analysis.R script assumes you have unzipped the UCI HAR data set in your current working directory, i.e. under your current directory, you have a directory called "UCI HAR Dataset".
###Description
The run_analysis.R script assembles a new tidy data set from the raw UCI HAR Dataset in the following order which was given for the course assignment.
####Step 1. Merge the training and test sets to create one data set.
The script uses a helper function to read in the subject, y (activity), and X data files and column bind them for both test and training data. The resulting test and training data are then row bound to create the merged test and training data.
####Step 2. Extract only the measurements on the mean and standard deviation for each measurement.
The features.txt file is read in, and then we create a meanStdSubset which selects all rows in the features data whose variable names contain either "-mean()" or "-std()". An index is then created by taking the corresponding numbers in the first column and adding 2 to each one since we added the Subject and Activity columns first in Step 1. We then append '1' and '2' to this index to account for the Subject and Activity columns. This index is then used to select the appropriate columns from the merged test and training data.
####Step 3. Use descriptive activity names to name the activities in the data set.
The second column of the merged data set is named "Activity", and then each activity level is replaced with its corresponding human readable label that was listed in activity_labels.txt
####Step 4. Appropriately label the data set with descriptive variable names.
A vector beginning with "Subject" and "Activity" and ending with the variable names in meanStdSubset from Step 2 is created. That elements in the vector are then assigned as the column names for the merged data set.
####Step 5. Create an independent tidy data set with the average of each variable for each activity and each subject.
The 'dplyr' package is installed if necessary, and then loaded. The merged data is arranged by Subject and Activity, then grouped by Subject Activity, and then finally summarized within each Subject/Activity group using the mean function. The new tidy data is then written out to tidy_data.txt
