// Calculates the square of a number
function square(number) {
  var square = number * number;
  console.log("The square of", number, "is", square);
  return square;
}

// Calculates the cube of a number
function cube(number) {
  var cube = number * number * number;
  console.log("The cube of", number, "is", cube);
  return cube;
}

// Calculates the average of an array of numbers
function average(numbers) {
  var sum = numbers.reduce(function (acc, curr) {
    return acc + curr;
  }, 0);
  var avg = sum / numbers.length;
  console.log("The average of the following numbers:",numbers,"is", avg);
  return avg;
}

var num = 7;
var arr = [17, 12, 33, 24, 45, 36, 18, 85, 97, 48];

var res1 = square(num);
var res2 = cube(num);
var res3 = average(arr);
