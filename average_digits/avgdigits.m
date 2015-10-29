1;
more off;

% load the dataset if it has not been loaded yet
if exist("trainX") == 0
	load("mnist.txt.gz");
end

X = 255 - trainX;  % invert the pixels

% show some examples
n = 15;
m = [];
for i = 0:n - 1
	d1 = reshape(X(i + 1, :), 28, 28)';
	d2 = reshape(X(i + 1 + n, :), 28, 28)';
	m = [m, [d1; d2]];
end

imshow(m, [0, 255]);

% statistics about the distribution of the digits in the training set, i.e.
% count the number of occurrences of each digit
for i = 0:9
	printf('%d: %d\n', i, sum(trainY == i));
end

display('press enter to see the averages ...');
pause;

% average the digits
r = [];
for i = 0:9
	rows = (trainY == i);
	n = sum(rows);
	d = reshape(sum(X(rows, :)) / n, 28, 28)';
	r = [r, d];
end

imshow(r, [0, 255]);
