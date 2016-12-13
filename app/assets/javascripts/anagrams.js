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
    updateText(response);
  })
  .fail(function(response){
    alert("Can't add subword");
  })
}

var updateText = function(response) {
  console.log(response);
  $('#remaining').html(response["text"]);
  $('#current-anagram').html(response["current"]);
  updateSubwords(response["subwords"]);
  updateAnagrams(response["anagrams"]);
}

var updateSubwords = function(list) {
  subwords = $('#subword-list')
  subwords.empty();
  for (i in list) {
    subwords.append("<li>" + list[i] + "</li>");
  }
}

var updateAnagrams = function(list) {

}