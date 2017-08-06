$(document).ready(function() {
  getDictionary();
  subwordForm();
  subwordLink();
  anagramLink();
  enableButton();
  saveAnagram();
});

var getDictionary = function () {
}

// Submit subword form
var subwordForm = function() {
  $("#subword-form").on("submit", submitForm);
}

var submitForm = function(event) {
  event.preventDefault();
  form = this;
  data=$(this).serialize();
  console.log(data);
  $.ajax({
    method: "post",
    url: "add_subword",
    data: data,
    dataType: 'json'
  })
  .done(function(response){
    updateText(response);
    form.reset();
    resetButton();
  })
  .fail(function(response){
    form.reset();
    resetButton();
    alert("Can't add subword");
  })
}

// Submit subword via link
var subwordLink = function() {
  $("#subword-list").on("click", ".subword", submitSubword);
}

var submitSubword = function(event) {
  var word =$(this).html();
  data = "subword=" + word;
  console.log(data);
  $.ajax({
    method: "post",
    url: "add_subword",
    data: data,
    dataType: 'json'
  })
  .done(function(response){
    updateText(response);
  })
  .fail(function(response){
    alert("Can't add subword");
  })
}

// Remove subword via link
var anagramLink = function() {
  $("#current-anagram").on("click", ".current-word", removeSubword);
}

var removeSubword = function(event) {
  var word =$(this).html();
  data = "subword=" + word;
  console.log(data);
  $.ajax({
    method: "post",
    url: "remove_subword",
    data: data,
    dataType: 'json'
  })
  .done(function(response){
    updateText(response);
  })
  .fail(function(response){
    alert("Can't remove subword");
  })
}

// var enableButton = function() {
//   $("#subword-field").on("focus", resetButton);
// }

// Why does button have to be reenabled manually?
var resetButton = function() {
  button = $('#subword-button')
  button.prop('disabled', false);
  button.val('Submit');
}

// Save anagram via form
var saveAnagram = function() {
  $("#submit-form").on("submit", submitAnagram);
}

var submitAnagram = function(event) {
  event.preventDefault();
  form = this;
  data=$(this).serialize();
  console.log(data);
  $.ajax({
    method: "post",
    url: "save",
    data: data,
    dataType: 'json'
  })
  .done(function(response){
    alert("Anagram saved!");
  })
  .fail(function(response){
    alert("Can't save anagram");
  })
}

// Update remaining text after adding or removing subword
var updateText = function(response) {
  console.log(response);
  $('#remaining').html(response["text"]);
  // $('#current-anagram').html(response["current"]);
  var currentWords = response["current"].split(" ");
  updateList('#current-anagram', currentWords, "current-word");
  updateList('#subword-list', response["subwords"], "subword");
  updateList('#anagrams', response["anagrams"], "anagram");
  // Enable submit button if anagram is complete
  if(response["text"].length == 0) {
    $('#submit-button').prop('disabled', false);
  }
  else {
    $('#submit-button').prop('disabled', true);
  }

}

var updateList = function(id, list, label) {
  listElement = $(id)
  listElement.empty();
  if(list.length == 0) {
    listElement.append("(none)");
  }
  else {
    for (i in list) {
      listElement.append("<li class='" + label + "'>" + list[i] + "</li>");
    }
  }
}