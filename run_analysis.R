#
# 1. Merge the training and test sets to create one data set.
#

# Merge the subject, y, and X data of a particular data type, e.g. "test" or
# "train" into one data frame.
getData <- function(dir, dataType) {
    dataDir <- paste(dir, "/UCI HAR Dataset/", dataType, "/", sep = "")
    
    subjectDataFile <- paste(dataDir, "subject_", dataType, ".txt", sep = "")
    yDataFile <- paste(dataDir, "y_", dataType, ".txt", sep = "")
    xDataFile <- paste(dataDir, "X_", dataType, ".txt", sep = "")
    
    subjectData <- read.table(subjectDataFile)
    yData <- read.table(yDataFile)
    xData <- read.table(xDataFile)
    
    cbind(subjectData, yData, xData)
}

# Merge the train and test data sets into one data set.
dataDir = getwd()
allData <- rbind(getData(dataDir, "train"), 
                 getData(dataDir, "test"))

#
# 2. Extract only the measurements on the mean and standard deviation for each 
#    measurement.
#

# Read in the features Data
featuresData <- read.table(paste(dataDir, "/UCI HAR Dataset/features.txt", 
                                 sep = ""))

# Exctract the values where the second column matches "mean()" or "std()"
meanStdSubset <- featuresData[grepl("-(std|mean)\\(", featuresData$V2) , ]

# Add 2 to the corresponding indices of each mean()/std() column since the first
# two columns in the allData set are the Subject and Activity
featuresIndex <- meanStdSubset$V1 + 2

# Add 1 and 2 to the start of the featuresIndex to account for the Subject and
# Activity columns
featuresIndex <- c(1, 2, featuresIndex)

# Select the Subject, Activity, "-mean()", and "-std()" columns in allData
allData <- allData[ , featuresIndex]

#
# 3. Use descriptive activity names to name the activities in the data set.
#

# Rename the second column to 'Activity'
colnames(allData)[2] <- "Activity"

# Per the information in activity_labels.txt, assign activity labels to their
# corresponding numeric values

# Create and relevel a factor according to activities and their corresponding
# numeric labels
allData$Activity[allData$Activity==1] <- "Walking"
allData$Activity[allData$Activity==2] <- "Walking Upstairs"
allData$Activity[allData$Activity==3] <- "Walking Downstairs"
allData$Activity[allData$Activity==4] <- "Sitting"
allData$Activity[allData$Activity==5] <- "Standing"
allData$Activity[allData$Activity==6] <- "Laying"

#
# 4. Appropriately label the data set with descriptive variable names
#
colnames(allData) <- c("Subject", "Activity", as.character(meanStdSubset$V2))

#
# 5. Create an independent tidy data set with the average of each variable for
#    each activity and each subject
#

# Install the dplyr package if necessary and load it
if ("dplyr" %in% rownames(installed.packages()) == FALSE) {
    install.packages("dplyr")
}
library(dplyr)

# Arrange the data by subject and activity, group it by subject and activity,
# and then calculate the means per subject and activity
allData <- arrange(allData, Subject,Activity)
allData <- group_by(allData, Subject,Activity)
allData <- summarise_each(allData, funs(mean))

write.table(allData, file="tidy_data.txt", row.names=FALSE)
