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

var enableButton = function() {
  $("#subword-field").on("focus", resetButton);
}

// This is not working for some reason
// Why is submit button being disabled by ajax submission?
var resetButton = function() {
  console.log($('#submit-button').val());
  $('#submit-button').prop('disabled', false);
  $('#submit-button').val('Submit');
}

var saveAnagram = function() {
  $("#submit-form").on("submit", submitAnagram);
}

var submitAnagram = function(event) {
  event.preventDefault();
  form = this;
  data = {};
  // Need to add subject text and anagram to data
  console.log(data);
  $.ajax({
    method: "post",
    url: "save",
    data: data,
    dataType: 'json'
  })
  .done(function(response){
    // hide form
  })
  .fail(function(response){
    alert("Can't save anagram");
  })
}

var updateText = function(response) {
  console.log(response);
  $('#remaining').html(response["text"]);
  // $('#current-anagram').html(response["current"]);
  var currentWords = response["current"].split(" ");
  updateList('#current-anagram', currentWords, "current-word");
  updateList('#subword-list', response["subwords"], "subword");
  updateList('#anagrams', response["anagrams"], "anagram");
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