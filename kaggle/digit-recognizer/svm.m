1;
addpath('libsvm-3.20/matlab');
more off;

% load the dataset if not loaded yet; if we execute the script more than
% once in the same environment this safes some time
if exist('data') == 0
	display('loading datasets ...');
	data = load('train.txt.gz');
	test = load('test.txt.gz') ./ 255;
end

m = size(test, 1);
X = data(:, 2:end) ./ 255;
y = data(:, 1);
testX = test;
testY = zeros(m, 1) - 1;

display('training ...');
tic
model = svmtrain(y, X, '-q');
toc

display('predicting ...');
tic
[labels, acc, prob] = svmpredict(testY, testX, model, '-q');
toc


% output is matrix
% each row stores the result for one example in the test set
% the first column denotes the imageid
% the second column denotes the predicted class
p = [(1:m)', labels];

f = fopen('result_svm.txt', 'w');
fdisp(f, 'imageid,label');
fclose(f);
csvwrite('result_svm.txt', p, '-append');
