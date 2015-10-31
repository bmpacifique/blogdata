# Kaggle "Digit Recognizer"

In [Kaggle](https://www.kaggle.com)'s "Digit Recognizer" competition the task is to correctly recognize handwritten digits between 0 and 9 (inclusive). The digits are taken from the famous [MNIST database of handwritten digits](http://yann.lecun.com/exdb/mnist/) which is a popular benchmarking dataset for this task. The original dataset contains 60,000 digits for training and 10,000 examples in the test set. In the Kaggle competition the training set contains 42,000 examples and 28,000 examples in the test set.

## kNN

A very simply classifier is the [k-nearest neighbor](https://en.wikipedia.org/wiki/K-nearest_neighbors_algorithm). It's some kind of brute force approach which I use quite often to get a first impression about the difficulty of the problem. kNN does not require a training phase but uses the whole training set as its model. Each unknown example that we want to classify is simply compared to all examples in the training set (that's why I like it to compare this algorithm with a brute force approach) for which the classes are known and a voting decides to which class the unknown example will be assigned to. Concretely, I compute the Euclidean distance between the unknown example and all training examples. Then, I take the k examples from the training set which are closest to the unknown example (i.e. for which the Euclidean distance is smallest) and select the class which occurs most often among those k examples.

[Octave](https://www.gnu.org/software/octave/) which is an open source alternative for MATLAB is well suited for this task because kNN can be implemented with just a few lines of codes and because the dataset can be modified interactively. Before we can start with Octave we need to convert the data into an appropriate format.

### Preprocessing

Before we can load the datasets into Octave we need to do some preprocessing to convert them into a readable format. Furthermore, we compress the data to reduce the requirements for storage, to safe bandwidth when syncing the data, etc. We download the original csv files and execute the following commands on the command line:

```bash
tail -n +2 train.csv | tr ',' ' ' | gzip > train.txt.gz
tail -n +2 test.csv | tr ',' ' ' | gzip > test.txt.gz
```

Each line removes the first line of the csv file which is just a description of the fields in the csv file. Then, commas are replaced by spaces and finally this data is compressed and is written into `train.txt.gz` and `test.txt.gz` respectively. I have added both files to the repository so that this step can also be skipped.

### Running

This is a very simple kNN approach in Octave for the Kaddle "Digit Recognizer" competition. The score that this solution achieves on the test dataset during the open competition is: 0.96800

```bash
octave -q knn.m
```


## SVM

0.93557

```
tar xzf libsvm-3.20.tar.gz
cd libsvm-3.20/matlab
octave
octave:1> make
octave:2> quit
cd ../..
octave -q svm.m
```
