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

	% count the occurences of each label
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
