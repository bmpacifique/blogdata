#!/usr/bin/env python

import scipy.io as sio
from sklearn.neighbors import KNeighborsClassifier

d = sio.loadmat("/home/dz/data/mnist/mnist.mat")
v = d["examples"][0, 0]

X = v['trainX']
testx = v['testX']
y = v['trainY']
testy = v['testY']

clf = KNeighborsClassifier(n_neighbors = 7, algorithm = 'brute')
clf.fit(X, y.ravel())

t = clf.predict(testx)
c = len([1 for i in zip(iter(testy.ravel()), iter(t)) if i[0] == i[1]])

n = testy.shape[0]
print("acc = %.2f%%" % (float(c) / n * 100))

