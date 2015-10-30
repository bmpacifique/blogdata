tail -n +2 train.csv | tr ',' ' ' | gzip > train.txt.gz
tail -n +2 test.csv | tr ',' ' ' | gzip > test.txt.gz

octave -q knn.m
