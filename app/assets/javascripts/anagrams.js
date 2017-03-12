$(document).ready(function() {
  getDictionary();
  subwordForm();
  subwordLink();
  anagramLink();
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
    url: "subword",
    data: data,
    dataType: 'json'
  })
  .done(function(response){
    form.reset();
    resetButton();
    updateText(response);
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
    url: "subword",
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
    url: "remove",
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

// Need to reset button manually?
var resetButton = function() {
  $('#submit-button').attr('disabled', false);
  $('#submit-button').val('Submit');
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