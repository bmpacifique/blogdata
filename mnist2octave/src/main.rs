extern crate rustml;

use std::fs::File;
use std::io::Write;

use rustml::datasets::MnistDigits;
use rustml::io::OctaveFormat;

fn main() {

    let (train_x, train_y) = MnistDigits::default_training_set().unwrap();
    let (test_x, test_y) = MnistDigits::default_test_set().unwrap();

    let s = train_x.to_octave_string("trainX") +
        &train_y.to_octave_string("trainY") +
        &test_x.to_octave_string("testX") +
        &test_y.to_octave_string("testY");
    
    File::create("mnist.txt")
        .unwrap()
        .write_all(s.as_bytes())
        .unwrap();
}
