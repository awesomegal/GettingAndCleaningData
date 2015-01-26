
if (!file.exists("data")) {dir.create("data")}
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url, destfile = "./Dataset.zip", method="auto")
unzip("./Dataset.zip")
labels <- read.table(paste("./UCI HAR Dataset", "activity_labels.txt", sep = "/"), col.names=c("labelcode","label")) # Load activity_labels.txt
features <- read.table(paste("./UCI HAR Dataset", "features.txt", sep = "/")) # Load features.txt
mainFeatureCodes <- grep("mean\\(|std\\(", features[,2]) # Determine main features
train_folder <- paste("./UCI HAR Dataset", "train", sep = "/") # Load data train directory
training_subject <- read.table(paste(train_folder, "subject_train.txt", sep = "/"), col.names ="subject")
training_data <- read.table(paste(train_folder, "X_train.txt", sep="/"), col.names = features[,2], check.names = FALSE)
training_data <- training_data[,mainFeatureCodes]
training_labels <- read.table(paste(train_folder, "y_train.txt", sep="/"), col.names = "labelcode")
dfTraining <- cbind(training_labels, training_subject, training_data)
test_folder <- paste("./UCI HAR Dataset", "test", sep = "/") # Load data from test directory 
test_subject <- read.table(paste (test_folder, "subject_test.txt", sep = "/"), col.names = "subject" )
test_data <- read.table(paste( test_folder, "X_test.txt", sep = "/"), col.names = features[,2], check.names = FALSE)
test_data <- test_data[,mainFeatureCodes]
test_labels <- read.table(paste(test_folder, "y_test.txt", sep = "/" ), col.names  = "labelcode")
dfTest <- cbind(test_labels, test_subject, test_data)
dfRbind <- rbind(dfTraining, dfTest) # join Test and Training datasets 
df <- merge(labels, dfRbind, by.x="labelcode", by.y="labelcode") # convert lable codes to text from labels
df <- df[ , -1]
library(reshape2); df_Reshape <- melt(df, id = c("label", "subject")) # reshape data 
df_Tidy <- dcast(df_Reshape, label + subject ~ variable, mean) # make tidy dataset with the average of each variable for each activity and each subject

