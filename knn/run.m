1;
more off;

params = 3:2:17;
a = [];
m = 10;
for k = params
	knn
	a = [a, acc];
end

plot(params, a, 'x', 'linestyle', '-', 'linewidth', 2, 'markersize', 10)
grid on
xlabel('k');
ylabel('accuracy');

csvwrite('accuracy.txt', [params', a']);
