$(document).ready(function() {
  getDictionary();
  subwordForm();
  
});

var getDictionary = function () {
  
}

var subwordForm = function() {
  $("#subword-form").on("submit", addSubword);
}

var addSubword = function(event) {
  event.preventDefault();
  form = this;
  targetURL=$(this).attr("action");
  method=$(this).attr("method");
  data=$(this).serialize();
  console.log(data);
  $.ajax({
    method: method,
    url: targetURL,
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

// Need to reset button manually?
var resetButton = function() {
  $('#submit-button').attr('disabled', false);
  $('#submit-button').val('Submit');
}

var updateText = function(response) {
  console.log(response);
  $('#remaining').html(response["text"]);
  $('#current-anagram').html(response["current"]);
  updateList('#subword-list', response["subwords"]);
  updateList('#anagrams', response["anagrams"]);
}

var updateList = function(id, list) {
  listElement = $(id)
  listElement.empty();
  if(list.length == 0) {
    listElement.append("(none)");
  }
  else {
    for (i in list) {
      listElement.append("<li>" + list[i] + "</li>");
    }
  }
}