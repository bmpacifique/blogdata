extern crate rustml;

use std::fs::File;
use std::io::Write;

use rustml::datasets::MnistDigits;
use rustml::csv::matrix_to_csv;
use rustml::matrix::{Matrix, IntoMatrix};

fn write(f: &mut File, m: Matrix<u8>, s: &str) {

    f.write_all(format!(
        "# name: {}\n# type: matrix\n# rows: {}\n# columns: {}\n{}\n\n",
        s, m.rows(), m.cols(), matrix_to_csv(&m, " ")
    ).as_bytes()).unwrap();
}

fn main() {

    let (train_x, train_y) = MnistDigits::default_training_set().unwrap();
    let (test_x, test_y) = MnistDigits::default_test_set().unwrap();

    let mut f = File::create("mnist.txt").unwrap();

    write(&mut f, train_x, "trainX");
    write(&mut f, train_y.to_matrix(train_y.len()), "trainY");
    write(&mut f, test_x, "testX");
    write(&mut f, test_y.to_matrix(test_y.len()), "testY");
}
