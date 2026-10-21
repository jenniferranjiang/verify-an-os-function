var numbers = [1, 2, 3, 4, 5];

function sumArray(arr) {
  var sum = arr.reduce(function (a, b) {
    return a + b;
  }, 0);
  console.log("Sum of array", arr, "is", sum);
  return sum;
}

var arraySum = sumArray(numbers);
