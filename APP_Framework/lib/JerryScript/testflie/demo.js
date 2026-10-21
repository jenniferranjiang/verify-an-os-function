//Quickly sort an array
function quickSort(array, start, end) {
      if (end - start < 1) {
        return;
      }
      const target = array[start];
      let l = start;
      let r = end;
      while (l < r) {
        while (l < r && array[r] >= target) {
          r--;
        }
        array[l] = array[r];
        while (l < r && array[l] < target) {
          l++;
        }
        array[r] = array[l];
      }
      array[l] = target;
      quickSort(array, start, l - 1);
      quickSort(array, l + 1, end);
      return array;
    }
    
const array = [5, 3, 8, 4, 2, 9, 1, 7, 6];
console.log("The array before sorting is:",array);
const sortedArray = quickSort(array, 0, array.length - 1);
console.log("The sorted array is:",sortedArray);