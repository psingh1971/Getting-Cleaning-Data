## Getting and Cleaning Data - Course Project 

### About the Project
The purpose of this project is to demonstrate the ability to collect, work with, and clean a data set. The goal is to a prepare tidy data that can be used for later analysis. 

Requirements for submission are:
  > 1. A tidy data set as described below,  
  > 2. A link to a Github repository with a script for performing the analysis, and  
  > 3. A code book that describes the variables, the data, and any transformations or work that was performed to clean up the data called CodeBook.md.   
  > 4. A README.md file in the repo. This repo explains how all of the scripts work and how they are connected.  
  

One of the most exciting areas in all of data science right now is wearable computing. Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained: [http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones][UCI]

[UCI]: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

Here are the data for the project: [https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip][Data]

[Data]: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip  

An R script has to be created called run_analysis.R that does the following: 
   > 1.	Merges the training and the test sets to create one data set.
   > 2.	Extracts only the measurements on the mean and standard deviation for each measurement. 
   > 3.	Uses descriptive activity names to name the activities in the data set.
   > 4.	Appropriately labels the data set with descriptive variable names. 
   > 5.	From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.


### Contents of this Repository
  > 1. README.md – The current file 
  > 2. run_analysis.R – The R script to perform the above tasks and create a tidy dataset
  > 3. CodeBook.md – The code book that provides details about the raw data, the process to transform it into two tidy datasets, and an explanation of the variables in these datasets.


### How to create the tidy dataset
  > 1. Open the R console or an RStudio session
  > 2. Copy the "run_analysis.R" file to your current working directory 
  > 3. The script in this .R file requires two external packages – plyr and dplyr
  > 4. Source the script using the following code: `source("run_analysis.R")`
  > 5. The script creates two tidy datasets and converts the secong summarized dataset into a space delimited text file called "tidydata.txt" in your current working directory. It has 180 rows and 68 columns and can be read into a data frame using the following code: `tidydata <- read.table("tidydata.txt", header=TRUE)`
  
  
