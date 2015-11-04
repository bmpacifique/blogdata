library(class)

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

X <- trainX
y <- factor(trainY)
t <- testX
m <- length(testY)

r <- knn(train = X, test = t, cl = y, k = 5)
c <- sum(r == testY)

cat(sprintf('%.2f\n', c / m * 100))

