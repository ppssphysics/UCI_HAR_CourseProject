CodeBook.md, created 23 December 2015

# Code Book for cleaning accelerometer dataset

This is the code book that explains the actions taken to clean the data collected
from the accelerometers from the Samsung Galaxy S smartphone based on the Coursera
"Getting and Cleaning Data" Course Project requirements.  

The R script used to produced the cleaning and final output tidy data set **UCI_HAR_Dataset_Tidy.txt**
is **run_analysis.R**. The steps is this code book are numbered identically to steps performed in
the run_analysis.R script.

To run the script in R : source("run_analysis.R")


## 1. Prepare working directory
   -------------------------
   * Searches for **UCI_HAR_Dataset** or **UCI HAR Dataset** directory. If not found, download the zip
     file again from URL and organizes directory with naming conventions (see below)
   * Renamed directories **UCI HAR Dataset** to **UCI_HAR_Dataset** and
     **Inertial Signals** to **Inertial_Signals** to avoid dealing
     with spaces. Use file.rename function in R.


## 2. Load all needed .txt files from UCI_HAR_Dataset
   --------------------------------------------------
   We are only working the already filtered data so no need to load the raw data
   present in the Inertial_Signals sub directories.

   We load the following files :

   Text File Name | Description | Row # | Col #
   -------------- | ----------- | ----- | -----
   features.txt   | full list of features (variable name) | 2 | 561
   activity_labels.txt | list of integer values referring to the activity | 2 | 6
   train/X_train.txt | measured features in training data set | 561 | 7352
   train/y_train.txt | training labels | 1 | 7352
   test/X_test.txt | measured features in testing data set | 561 | 2947
   test/y_test.txt | testing labels | 1 | 2947

   "features.txt" basically gives the description of the 561 columns of the X_*.txt
   columns and "activity_labels.txt" the association between the integer in the
   y_*.txt column and an activity.


## 3. Merge the training and testing data sets
   ----------------------------------------
   * checks column numbers are the same before binding data sets by row (rbind)
   * merge separately y_*.txt and X_*.txt files
   * results in "all_lab" and "all_set" tables
   * After merging, also checked if missing values using colSums(is.na(all_lab))
     and colSums(is.na(all_set)). No values missing.


## 4. Rename column names and activity labelling
   ------------------------------------------
   * rename column names using "Activity" and features.txt descriptions
     to rename columns of the binded "all_lab" and "all_set" tables respectively.
   * rename Activity label column in "all_lab" table using descriptive names
     using the table provided in activity_labels.txt
     example: Instead of 1 we have WALKING, etc.


## 5. Subset table: keep mean and std calculations for each variable
   -------------------------------------------------------------------
   * We do this by grepping on column names that contain the "mean" or "std"
     string of characters (no case-sensitivity and no exact match required).
     Result is a table of 79 remaining columns.


## 6. Add activity column to subsetted data set
   ---------------------------------------------------------------
   * Use cbind() function to add the activity labelling corresponding to
     all observations (i.e. rows)


## 7. Summarize the data to get mean of variables by activity group
   -----------------------------------------------------------------
   * Use "group_by" and "summarise_each" functions provided by dplyr package.
     The result is a tidy dataset with 6 rows (each type of activity). On each row
     is given the mean of the 79 variables for each corresponding activity.
   * Example of the data set structure below:

     Activity | tBodyAcc-mean()-X | tBodyAcc-mean()-Y | tBodyAcc-mean()-Z | ...
     -------- | ----------------- | ----------------- | ------------------| ---
     WALKING         | 0.2763369   |    -0.01790683    |    -0.1088817 | ...
     WALKING_UPSTAIRS |         0.2622946    |   -0.02592329     |   -0.1205379 | ...
     WALKING_DOWNSTAIRS |         0.2881372   |    -0.01631193   |     -0.1057616 | ...
     SITTING     |    0.2730596   |    -0.01268957    |    -0.1055170 | ...
     STANDING    |     0.2791535   |    -0.01615189   |     -0.1065869 | ...
     LAYING      |   0.2686486   |    -0.01831773     |   -0.1074356 | ...


## 8. Save the data in output text file named
   -------------------------------------------
   * Use write.table() function with row.name=FALSE
   * Saves output file **UCI_HAR_Dataset_Tidy.txt** in working directory
