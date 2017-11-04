$(document).ready(function() {
  getDictionary();
  subwordForm();
  subwordLink();
  anagramLink();
  enableButton();
  saveAnagram();
  countChars();
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

var enableButton = function() {
  $("#subword-field").on("focus", resetButton);
}

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
  updateList('#current-anagram', currentWords, "selectable current-word");
  updateList('#subword-list', response["subwords"], "selectable subword");
  updateList('#anagrams', response["anagrams"], "anagram");
  // Enable submit button if anagram is complete
  if(response["text"].length == 0) {
    $('#submit-button').prop('disabled', false);
  }
  else {
    $('#submit-button').prop('disabled', true);
  }
  // Enable reset button if anagram is non-empty
  if(response["current"].length == 0) {
    $('#reset-button').prop('disabled', true);
  }
  else {
    $('#reset-button').prop('disabled', false);
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


// Reset anagram via form
var saveAnagram = function() {
  $("#reset-form").on("submit", resetAnagram);
}

var resetAnagram = function(event) {
  event.preventDefault();
  // form = this;
  console.log(data);
  $.ajax({
    method: "post",
    url: "reset"
  })
  .done(function(response){
    location.reload();
  })
  .fail(function(response){
    alert("Can't reset anagram");
  })
}

var countChars = function() {
  $("#anagram-editor").on("input", inputChars);
}

var inputChars = function(event) {
  var remainingText = $("#subject-text").val().simplify().sort();
  var lettersUsed = $("#letters-used").val();
  // var maxLength = this.getAttribute("maxlength");
  var currentAnagram = this.value.simplify();
  var result = remainingText.subtract(currentAnagram);
  if(result == null) {
    $(".letters-verified").css("color", "red");
  }
  else {
    if(result == "") $(".letters-verified").css("color", "blue");
    else $(".letters-verified").css("color", "black");
    $("#letters-used").val(currentAnagram.sort());
    $("#remaining-text").val(result);
  }


  var charCount = $("#char-count");
  charCount.html("Anagram (" + currentAnagram.length + " letters)")
}