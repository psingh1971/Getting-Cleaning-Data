## Getting and Cleaning Data - Code Book

## Raw Data

### Source

The raw data for the project comes from the UCI Machine Learning Repository. The data set is titled *Human Activity Recognition Using Smartphones Data Set*. The URL is: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones


### Raw Data Collection

The data was collected by the original researchers using experiments carried out on a group of 30 volunteers within the age bracket of 19-48 years. Each person performed six activities (walking, walking upstairs, walking downstairs, sitting, standing, and laying) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, 3-axial linear acceleration and 3-axial angular velocity were captured at a constant rate of 50Hz. The obtained dataset was randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cut off frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domains.

The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals (**time domain**) that were captured at a constant rate of 50 Hz. Then they were filtered to remove noise. The acceleration signal was then separated into Body and Gravity acceleration signals. 

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals. Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm. 

Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing **frequency domain** signals. These signals were used to estimate variables of the feature vector for each pattern:  '-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

The set of variables that were estimated from these signals are: 

mean(): Mean value  
std(): Standard deviation  
mad(): Median absolute deviation   
max(): Largest value in array  
min(): Smallest value in array  
sma(): Signal magnitude area   
energy(): Energy measure. Sum of the squares divided by the number of values  
iqr(): Interquartile range   
entropy(): Signal entropy  
arCoeff(): Autorregresion coefficients with Burg order equal to 4   
correlation(): correlation coefficient between two signals   
maxInds(): index of the frequency component with largest magnitude   
meanFreq(): Weighted average of the frequency components to obtain a mean frequency  
skewness(): skewness of the frequency domain signal   
kurtosis(): kurtosis of the frequency domain signal    
bandsEnergy(): Energy of a frequency interval within the 64 bins of the FFT of each window   
angle(): Angle between to vectors    

Note: Features in the raw data were normalized and bounded within [-1,1].


## The Transformation of Raw Data

The included script run_analysis.R was used to transform the above mentioned raw data into a analysis ready tidy dataset. 

The following raw data files were used in preparation of the tidy data:

1. 'features.txt': Contains labels for the features (561 rows, 2 columns: ID and feature label).
2. 'activity_labels.txt': Contains labels for activities (6 rows, 2 columns: activity ID and activity label)
3. 'train/X_train.txt': All features collected for all training subjects (7352 rows, 561 columns)
4. 'test/X_test.txt': All features collected for all test subjects (2947 rows, 561 columns)
5. 'train/y_train.txt': Outcome (activity) for all training subjects (7352 rows, 1 column)
6. 'test/y_test.txt': Outcome (activity) for all test subjects (2947 rows, 1 column)
7. 'train/subject_train': Subject ID for all training subjects (7352 rows, 1 column)
8. 'test/subject_test': Subject ID for all test subjects (2947 rows, 1 column)

### Transformation Steps

The run_analysis.R script performs the following steps:

*1. Download the raw data & upzip it*
The UCI HAR dataset is downloaded from the following URL: "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip into the "./data" sub-folder within the root directory. The zipped files are extracted into the the "./data/UCI HAR Dataset" sub-folder.

*2. Read the files into datasets*
The activity, training, and subject files mentioned above are read into datasets.

*3. Combine the training and test datasets*
The datasets are combined together vertically (concatenated) in the order given here: feature datasets (train + test), activity datasets (train + test), subject datasets (train + test). Now we have 3 datasets Activity(10,299 rows, 1 column), Subject(10,299 rows, 1 column), Features(10,299 rows, 561 columns). Descriptive column names are assigned to each of these 3 datasets. The column names for the Features dataset are taken from the "features.txt" file.

*4. Combine the Subject, Feature, and Activity datasets*
These datasets are now horizontally combined to create one wide dataset with 10,299 rows and 563 columns.

*5. Extract features pertaining to mean and standard deviation*
From the dataset above, features that contain either mean() or std() in their names are retained along with subject ID and activity ID. The resulting dataset, named FinalData, has 10,299 rows and 68 columns.

*6. Use descriptive activity names*
Activity labels are read from the 'activity_labels.txt' file and horizontally merged with the dataset above on activity ID to assign descriptive name to each activity. Then the activity names are cleaned to remove underscores and converted to lower case (e.g. walking, walkingupstairs, walkingdownstairs, sitting, standing, and laying).

*7. Appropriately label the dataset with descriptive names*
Feature labels were made clearer by removing parenthesis and making them self explanatory.

*8. Create a second tidy dataset*
The first tidy dataset (FinalData)contains multiple observations pertaining to multiple time windows for each combination of subject and activity. It was summarized to produce average of all features for each activity and subject combination. This dataset (TidyData) has 180 rows and 68 columns. The dataset is then written into a text file - "tidydata.txt".

### Description of Variables in the Tidy Datasets

Both tidy datasets have the same number of variables. The first dataset created by the transformation process contains multiple observations for each combination of subject and activity, while the second tidy dataset is summarized to contain averages of features for each subject and activity. Both datasets have 68 columns which include:  

1. subject: contains the ID assigned to each subject in the experiment. 30 unique values ranging from 1 to 30.
2. activity: activities performed by subjects. 6 unique values (walking, walkingupstairs, walkingdownstairs, sitting, standing, and laying)
3. A 66 feature vector containing time and frequency signals (numeric). These variables are grouped into the following categories:
Body Acceleration, Gravity Acceleration, Body Acceleration Jerk, Body Angular Speed, Body Angular Acceleration, Body Acceleration Magnitude,
Gravity Acceleration Magnitude, Body Acceleration Jerk Magnitude, Body Angular Speed Magnitude, and Body Angular Acceleration Magnitude.
4. There is at least one time domain variable for each one of these category. These variables begin with the prefix "time". For example - timeBodyAcceleration-Mean-X. 
5. There are some frequency domain variables for some of these categories. These variables begin with the prefix "frequency". For example - frequencyBodyAngularAccelerationMagnitude-Mean
6. For the above categories, given either time or frequency domain, there are variables that capture either Mean or Standard Deviation.
7. Some variables end with a -X, -Y, or -Z suffix. That denotes the dimension along which the signal was measured. For example, the variable timeBodyAccelerationJerk-Mean-Y contains time domain data for Body Acceleration Jerk which is a mean of the all the observations for this metric taken on the Y axis.



References

1. Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. A Public Domain Dataset for Human Activity Recognition Using Smartphones. 21th European Symposium on Artificial Neural Networks, Computational Intelligence and Machine Learning, ESANN 2013. Bruges, Belgium 24-26 April 2013.

2. http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

3. Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012

