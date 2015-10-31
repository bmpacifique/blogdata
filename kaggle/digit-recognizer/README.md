# Kaggle "Digit Recognizer" Competition

In [Kaggle](https://www.kaggle.com)'s "Digit Recognizer" competition the task is to correctly recognize handwritten digits between 0 and 9 (inclusive). The digits are taken from the famous [MNIST database of handwritten digits](http://yann.lecun.com/exdb/mnist/) which is a popular benchmarking dataset for this task. The original dataset contains 60,000 digits for training and 10,000 examples in the test set. In the Kaggle competition the training set contains 42,000 examples and 28,000 examples in the test set.

## kNN

A very simply classifier is the [k-nearest neighbor](https://en.wikipedia.org/wiki/K-nearest_neighbors_algorithm). It's some kind of brute force approach which I use quite often to get a first impression about the difficulty of the problem. kNN does not require a training phase but uses the whole training set as its model. Each unknown example that we want to classify is simply compared to all examples in the training set (that's why I like it to compare this algorithm with a brute force approach) for which the classes are known and a voting decides to which class the unknown example will be assigned to. Concretely, I compute the Euclidean distance between the unknown example and all training examples. Then, I take the k examples from the training set which are closest to the unknown example (i.e. for which the Euclidean distance is smallest) and select the class which occurs most often among those k examples.

This approach is computational expensive. The naive implementation takes O(nm) time (n = number of training examples, m = number of dimensions) to compute the distance between the unkown example and all examples in the training set plus the time required to find the k smallest distances which is O(n log n) for a naive implementation. Nevertheless, for a first impression the naive approach is quite useful and while the classification is running I use the time to start thinking about the problem.

[Octave](https://www.gnu.org/software/octave/) is an open source alternative for MATLAB and is well suited for this task because kNN can be implemented with just a few lines of codes and because the dataset can be modified interactively.

### Preprocessing

Before we can load the datasets into Octave we need to do some preprocessing to convert them into a readable format. Furthermore, we compress the data to reduce the requirements for storage, to safe bandwidth when syncing the data, etc. I like to keep everything small. The smaller the repository the faster I can start with my experiments when cloning the repository on another computer.

We download the original csv files and execute the following commands on the command line:

```bash
tail -n +2 train.csv | tr ',' ' ' | gzip > train.txt.gz
tail -n +2 test.csv | tr ',' ' ' | gzip > test.txt.gz
```

Each line removes the first line of the csv file which is just the description of the fields in the csv file. Then, commas are replaced by spaces and finally this data is compressed and is written into `train.txt.gz` and `test.txt.gz` respectively. I have added both files to the repository so that this step can also be skipped.

### Running

It's time for action!

We write a script which reads the training and test set, predicts the label for each example in the test set and writes the result (i.e. the labels for each example in the test set) into a file in a format that can be uploaded directly to the Kaggle competition without any additional postprocessing. The script is saved into the file `knn.m` and is shown below:

```matlab
1;
more off;

% load the dataset if not loaded yet; if we execute the script more than
% once in the same environment this safes some time
if exist('X') == 0
	display('loading datasets ...');
	data = load('train.txt.gz');
	X = data(:, 2:end) ./ 255;
	y = data(:, 1);
	t = load('test.txt.gz') ./ 255;
end

m = size(t, 1); % number of test examples
k = 5;          % number of neighbors to examine

l = [];
tic
for i = 1:m
	% subtract the example t(i, :) from each row in X
	d = bsxfun(@minus, X, t(i, :));
	% sum the squared elements for each row and compute the square root
	% for each sum
	r = sqrt(sumsq(d, 2));

	% sort the distances and get the labels of the first k items
	[tmp, idx] = sort(r);
	labels = y(idx(1:k), 1);

	% count the occurrences of each label
	u = unique(labels);
	counts = arrayfun(@(x) sum(labels == x), u);
	[tmp, idx] = sort(counts, 'descend');

	% append the predicted label to l
	l = [l; u(idx(1, 1))];
	printf(' %d / %d\r', i, m);
end
printf('\n');
toc

% output is matrix
% each row stores the result for one example in the test set
% the first column denotes the imageid
% the second column denotes the predicted class
p = [(1:m)', l];

f = fopen('result_knn.txt', 'w');
fdisp(f, 'imageid,label');
fclose(f);
csvwrite('result_knn.txt', p, '-append');
```

To execute the script we change into the directory where the files `train.txt.gz` and `test.txt.gz` are located. Then we start Octave and in Octave we can simply start the script by typing `knn`. Alternatively, we can also start the script on the command line via `octave -q knn`. However, running a script in the Octave environment has the advantage that we can run it several times (e.g. with different parameters) without reloading the dataset each time.

When the script is finished the result is stored in the file `result_knn.txt`.

## SVM

[Support Vector Machines (SVM)](https://en.wikipedia.org/wiki/Support_vector_machine) are also a very popular learning algorithm for classification tasks. Because Octave has no built-in support for Support Vector Machines we have to use a third party library. Fortunately [LIBSVM](https://www.csie.ntu.edu.tw/~cjlin/libsvm/) provides an interface for MATLAB and Octave so it is well suited for our purpose. We just have to download the latest version which can also be found in this repository and have to compile the sources. Just execute the commands on the command line shown below:

```bash
tar xzf libsvm-3.20.tar.gz
cd libsvm-3.20/matlab
octave
octave:1> make
octave:2> quit
cd ../..
```

Note: If the `make` fails it is very likely that you are missing the development packacke of Octave. On Ubuntu you can install this package with `sudo apt-get install liboctave-dev`.

Now, you can start the svm script with `octave -q svm.m` or by starting Octave and typing `svm` on the Octave prompt. The result is stored in the file `result_svm.txt`.

## Summary of performance

In the following table the accuracy (proportion of correctly classified examples) and the time required for training and testing is summarized for each learning algorithm.

| Method | Time for training | Time for classification | Accuracy |
|--------|------------------:|------------------------:|---------:|
| kNN    |     0s            |  86min 17s              | 96.80%   |
| SVM    |     5min 14s      |  12mn 40s               | 93.56%   |

## Sources

The sources are available on [GitHub](https://github.com/daniel-e/blogdata/tree/master/kaggle/digit-recognizer).

