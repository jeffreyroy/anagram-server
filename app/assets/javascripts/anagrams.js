/// String methods useful for anagramming

// Remove all non-letter characters
// And convert all letters to lower case
String.prototype.simplify = function() {
  return this.replace(/[^A-Za-z]/g, '').toLowerCase();
}

// Sort into alphabetical order
String.prototype.sort = function() {
  return this.split('').sort().join('');
};

// Return result when letters of substring are removed
// Or null if not a substring
String.prototype.subtract = function(substring) {
  var result = this
  // Loop through substring
  for(i=0; i<substring.length; i++) {
    var char = substring[i];
    // Check whether letter is found
    var newResult = result.replace(char, '');
    // If not, return null
    if(newResult == result) return null; 
    // Otherwise, remove letter and continue
    else result = newResult;
  }
  return result;
}