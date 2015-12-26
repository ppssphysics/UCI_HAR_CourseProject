
# 10.12.2015, P. Saouter
# Data Science Specialization - Getting and Cleaning Data
# Course Project


# 1. If data directory not there, retireve it from URL
######################################################

if (!(dir.exists("UCI_HAR_Dataset"))) {

  # Retrieve data from server

  print("1.The data was not found in local directory, retrieving from server")
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileURL,destfile="./SamsungGSData",method="curl")
  dateDownload <- date()
  cat("Downloaded file date :"); dateDownload # cat to avoid new line
  unzip("./SamsungGSData")

  # Rename directory "UCI HAR Dataet" and "Inertial Signals"

  file.rename("UCI\ HAR\ Dataset","UCI_HAR_Dataset")
  file.rename("UCI_HAR_Dataset/train/Inertial\ Signals","UCI_HAR_Dataset/train/Inertial_Signals")
  file.rename("UCI_HAR_Dataset/test/Inertial\ Signals","UCI_HAR_Dataset/test/Inertial_Signals")
}
if (dir.exists("UCI_HAR_Dataset")) print("1. Using UCI_HAR_Dataset found in local dir for analysis")

# 2. Load all relevant files into data frames
##########################################

print("2. Loading all needed text files for the cleaning")

# Load Header files

feature <- read.table("UCI_HAR_Dataset/features.txt") # 561 different variable
act_lab <- read.table("UCI_HAR_Dataset/activity_labels.txt") # links activity with integer # 6 rows

# Load training and test data sets

trn_set <- read.table("UCI_HAR_Dataset/train/X_train.txt"); # 561 col, 7352 rows --> actual measurements
trn_lab <- read.table("UCI_HAR_Dataset/train/y_train.txt"); # 7352 rows --> list interger values (activity?)
tst_set <- read.table("UCI_HAR_Dataset/test/X_test.txt"); # 561 col, 2947 rows -->
tst_lab <- read.table("UCI_HAR_Dataset/test/y_test.txt"); # 2947 rows --> list interger values (activity?)s

# 3. Merge training and testing data sets
#########################################

# add rows test data set to train data set after checking same column number

if(ncol(trn_lab)==ncol(tst_lab)) {
  print("3. Merging training and testing datasets by row")
  # activity labels
  all_lab <- rbind(trn_lab,tst_lab) # 1 col, 10299 rows
  # activity measurements
  all_set <- rbind(trn_set,tst_set) # 561 cols, 10299 rows
}
if(ncol(trn_lab)!=ncol(tst_lab)) {
  print("3. Trying to rbind tables with different column numbers...")
}

# 4. Renaming columns based on acitvity names and variable names
################################################################

print("4. Renaiming some variables in tables")

c1names <- c("Activity"); colnames(all_lab) <- c1names
c2names <- feature[,2]; colnames(all_set) <- c2names

actlabel = act_lab[,1]
actnames = act_lab[,2]
all_lab$Activity <- factor(all_lab$Activity,levels = actlabel,labels = actnames)

# 5. Subset table keeping only mean and std calculation for each variable
#########################################################################

print("5. Subsetting the measurements")

sub_set <- all_set[,grepl("mean|std", colnames(all_set))]

# 6. Add the activity column
############################

print("6. Creating final dataset with activity column")

fin_set <- cbind(all_lab,sub_set)

# 7. Create a tidy dataset with mean of all variables for each activity
# #####################################################################

print("7. Creating tidy data set with mean of variables by activity")

tidyset <- fin_set %>% group_by(Activity) %>% summarise_each(funs(mean))
tidyset

# 8. Save the tidy dataset as text file in working directory
# #####################################################################

print("8. Saving tidy data set in output textfile")

tidyset <- write.table(tidyset,"UCI_HAR_Dataset_Tidy.txt",row.name=FALSE)
