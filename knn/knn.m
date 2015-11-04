1;
more off;

% load the dataset: trainX, trainY, testX, testY
if exist('trainX') == 0
	display('loading the dataset ...');
	load('mnist.txt.gz');
end

% preprocessing of the datasets
X = trainX ./ 255;
t = testX ./ 255;

% settings
if exist('m') == 0
	m = size(t, 1);  % number of test examples
end
if exist('k') == 0
	k = 5;    % number of neighbors to examine
end
printf('m = %d, k = %d\n', m, k);

% prediction
c = 0;
for i = 1:m
	d = bsxfun(@minus, X, t(i, :));
	r = sqrt(sumsq(d, 2));
	[tmp, idx] = sort(r);
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

% accuracy
acc = c / m
