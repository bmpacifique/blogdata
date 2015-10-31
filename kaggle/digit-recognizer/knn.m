1;
more off;

if exist('X') == 0
	display('loading datasets ...');
	data = load('train.txt.gz');
	X = data(:, 2:end) ./ 255;
	y = data(:, 1);
	t = load('test.txt.gz') ./ 255;
end

m = size(t, 1);  % number of test examples
k = 5;           % number of neighbors to examine

l = [];
tic
for i = 1:m
	d = bsxfun(@minus, X, t(i, :));
	r = sqrt(sumsq(d, 2));
	[tmp, idx] = sort(r);
	labels = y(idx(1:k), 1);
	u = unique(labels);
	counts = arrayfun(@(x) sum(labels == x), u);
	[tmp, idx] = sort(counts, 'descend');
	l = [l; u(idx(1, 1))];
	printf(' %d / %d: \r', i, m);
end
printf('\n');
toc

p = [(1:m)', l];


f = fopen('result_knn.txt', 'w');
fdisp(f, 'imageid,label');
fclose(f);
csvwrite('result_knn.txt', p, '-append');
