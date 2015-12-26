# CodeBook.md, created 23 December 2015
# Code Book for cleaning accelerometer dataset

# Explaining actions taken to clean data set
# implemented in R script "run_analysis.R"

# To run the script:
> source("run_analysis.R")


###########################################################
# Steps are numbered identically to steps performed in the
# run_analysis.R script.
###########################################################


1. Prepare working directory
   -------------------------
   - Searches for "UCI_HAR_Dataset" directory. If not found, download the zip
     file again from URL and organizes directory with naming conventions (see below)
   - Renamed directories "UCI HAR Dataset" "UCI_HAR_Dataset" and
     "Inertial Signals" to "Inertial_Signals" to avoid dealing
     with spaces. Use file.rename function in R.


2. Load all needed .txt files in UCI_HAR_Dataset dir into data frames
   ------------------------------------------------------------------
   We are not working directly with the raw data in the Inertial_Signals
   directories of the train and test data so no need to load these.
   We load the following files :

   - features.txt // full list of features (variable name)
   - activity_labels.txt // list of integer values referring to the activity
   - train/X_train.txt // measured features in training data set (561 col, 7352 rows)
   - train/y_train.txt // training labels (1 col, 7352 rows)
   - test/X_test.txt // measured features in testing data set (561 col, 2947 rows)
   - test/y_test.txt // testing labels (1 col, 2947 rows)

   "features.txt" basically gives the description of the 561 columns of the X_*.txt
   columns and "activity_labels.txt" the association between the integer in the
   y_*.txt column and an activity.


3. Merge the training and testing data sets
   ----------------------------------------
   - checks column numbers are the same before binding data sets by row (rbind)
   - merge separately y_*.txt and X_*.txt files
   - results in "all_lab" and "all_set" tables

   - After merging, also checked if missing values using colSums(is.na(all_lab))
     and colSums(is.na(all_set)).


4. Rename column names and activity labelling
   ------------------------------------------
   - rename column names using "Activity" and features.txt descriptions
     to rename columns of the binded "all_lab" and "all_set" tables respectively.
   - rename Activity label column in "all_lab" table using descriptive names
     using the table provided in activity_labels.txt


5. Subset table keeping only mean and std calculations for each variable
   ---------------------------------------------------------------------
   We do this by grepping on column names that contain the "mean" or "std"
   string of characters (no case-sensitivity and no exact match required).
   Result is a table of 79 remaining columns.


6. Add the corresponding activity column to the subsetted data set
   ---------------------------------------------------------------
   Use cbind() function to add the activity labelling corresponding to
   all observations (i.e. rows)


7. Summarize the data to get mean of all variables by activity group
   -----------------------------------------------------------------
   Use "group_by" and "summarise_each" functions provided by dplyr package.
   The result is a tidy dataset with 6 rows (each type of activity). On each row
   is given the mean of the 79 variables for each corresponding activity.


8. Save the data in ouput text file
   -----------------------------------------------------------------
   Use write.table() function with row.name=FALSE
