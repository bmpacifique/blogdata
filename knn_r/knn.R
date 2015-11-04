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

