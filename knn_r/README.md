# k-Nearest Neighbors on MNIST handwritten digits with R

In a [previous blog post](http://daniel-e.github.io/2015-08-10-k-nearest-neighbours-on-mnist-digits-with-octave/) we have seen how to achieve a surprisingly good classification accuracy of 96.33% on the MNIST database of handwritten digits with a very simple k-Nearest Neighbor approach.

In this blog post I'm going to show how to do this in [R](https://www.r-project.org/). R is an interpreted programming language that is freely available under the GNU General Public License and was primarily developed for statistical computing and graphics. R has becoming very popular during the last few years among data miners and in the machine learning research community because it is well suited for fisualizing data, running statistical tests and applying machine learning algorithms. It is heavily used in [Kaggle competitions](https://www.quora.com/How-useful-is-Matlab-for-Kaggle-as-compared-with-R-and-Python) and it is quite common that new cutting-edge methods are implemented in R first. For example, Twitter has released a new method for [anomaly detection in a time series ](https://blog.twitter.com/2015/introducing-practical-and-robust-anomaly-detection-in-a-time-series) in R. Thus, the chances are good that you can directly profit from new research when knowing R.

## Dataset

The MNIST database of handwritten digits (see [here](http://yann.lecun.com/exdb/mnist/)) is a very popular dataset used by the machine learning research community for testing the performance of classification algorithms. It contains 60,000 labeled training examples of handwritten digits from 0 to 9 (including) and 10,000 labeled examples for testing. Each digit is represented as a grayscale image each with a width and height of 28 pixels. The value of a pixel is in the interval [0, 255].

## Code

```
readfile <- function(n) {
	m <- as.matrix(read.csv(gzfile(n), sep = ',', header = F))
	return(m)
}

if (!exists('trainX')) {
	cat('loading datasets...\n')
	trainX <- readfile('trainX.csv.gz')
	trainY <- readfile('trainY.csv.gz')
	testX <- readfile('testX.csv.gz')
	testY <- readfile('testY.csv.gz')
}

cat('training set: ', dim(trainX), '\n')
cat('test set    : ', dim(testY), '\n')

m <- length(testY)  # number of test examples
k <- 5
c <- 0

# iterate through the test examples and predict the class
# for each of them
for (i in 1:m) {
	# compute the Euclidean distance
	d <- t(t(trainX) - testX[i, ])
	r <- sqrt(rowSums(d ^ 2))

	# sort the distances
	idx <- sort(r, index.return = T)$ix

	# get the labels of the examples in the training set
	# which are closest to the current test example
	labels <- trainY[idx[1:k],]

	# for each unique label count its occurrences
	u <- unique(labels)
	counts <- sapply(u, function(x) sum(labels == x))

	# sort the occurrences in decreasing order
	idx <- sort(counts, index.return = T, decreasing = T)$ix

	# assign the label to the test example which occurs
	# most often
	if (u[idx[1]] == testY[i, 1]) {
		c <- c + 1
	}

	# statistics
	cat(sprintf("%d / %d -> %.2f%%\n", i, m, c / i * 100))
}
```

## Source

The code is also available on [GitHub](https://github.com/daniel-e/blogdata/tree/master/knn).

To run the example you have to clone the repository, change into the directory `knn_r` and run the script with `Rscript`. 

```bash
git clone https://github.com/daniel-e/blogdata.git
cd knn_r
Rscript knn.R
```

