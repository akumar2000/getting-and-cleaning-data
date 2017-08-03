
        library(reshape2)

        filename <- "getdata_dataset.zip"

        ## Download and unzip the dataset:
        if (!file.exists(filename)){
        fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
        download.file(fileURL, filename, method="curl")
        }  
        if (!file.exists("UCI HAR Dataset")) { 
                unzip(filename) 
        }
        

        train <- read.table("train/X_train.txt")
        activitiesTrain <- read.table("train/y_train.txt")
        subjectTrain <- read.table("train/subject_train.txt")
        train <- cbind(activitiesTrain, subjectTrain, train)

        test <- read.table("test/X_test.txt")
        activitiesTest <- read.table("test/y_test.txt")
        subjectTest <- read.table("test/subject_test.txt")
        test <- cbind(activitiesTest,subjectTest, test)

        allData <- rbind(train, test)

        activityLabel <- read.table("activity_labels.txt")
        features <- read.table("features.txt")

        activityLabel[,2] <- as.character(activityLabel[,2])
        features[,2] <-   as.character(features[,2])

        
        wantedFeatures <- grep("*mean.*| *std.*", features[,2])
        
        wantedFeatures.names <- features[wantedFeatures, 2]
        
        wantedFeatures.names = gsub('-mean', 'Mean', wantedFeatures.names)
        wantedFeatures.names = gsub('-std', 'Std', wantedFeatures.names)
        wantedFeatures.names <- gsub('[-()]', '', wantedFeatures.names)
        
        colnames(allData) <- c("subject","activity",wantedFeatures.names)

        allData$activity <- factor(allData$activity, levels = activityLabel[,1], labels = activityLabel[,2])
        allData$subject <- as.factor(allData$subject)

        
        allData.melted <- melt(allData, id = c("subject", "activity"))
        allData.mean <- dcast(allData.melted, subject + activity ~ variable, mean)
        
        
        write.table(allData.mean, "tidy.txt", row.names = FALSE, quote = FALSE)
