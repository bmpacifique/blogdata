1;
more off;

if exist('trainX') == 0
	display('loading the dataset ...');
	load('mnist.txt.gz');
end

X = trainX ./ 255;
Y = testX ./ 255;

m = size(testX, 1);  % number of test examples
k = 5;               % number of neighbours to examine

c = 0;
for i = 1:m
	% compute the euclidean distance
	% first, substract the test example from each row of X
	d = bsxfun(@minus, X, Y(i, :));
	% second, sum up the squared values of each row and compute the square root
	r = sqrt(sumsq(d, 2));
	[tmp, idx] = sort(r);
	% get the labels of the k nearest neighbours
	labels = trainY(idx(1:k), 1);
	u = unique(labels);
	counts = arrayfun(@(x) sum(labels == x), u);
	[tmp, idx] = sort(counts, 'descend');

	if u(idx(1, 1)) == testY(i, 1)
		c += 1;
	end
	printf(" %d / %d: %.2f%%    \r", i, m, c / i * 100);
end
printf("\n");

