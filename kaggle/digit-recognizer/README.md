This is a very simple kNN approach for the Kaddle "Digit Recognizer" competition. The score that this solution achieves on the test dataset during the open competition is: 0.96800

```bash
tail -n +2 train.csv | tr ',' ' ' | gzip > train.txt.gz
tail -n +2 test.csv | tr ',' ' ' | gzip > test.txt.gz
octave -q knn.m
```
