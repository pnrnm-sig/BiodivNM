// load lazy the images
$(".lazy").lazy();
// load lazy on scroll
$("#taxonListArea").scroll(function() {
  $(".lazy").lazy();
});
$('[data-toggle="tooltip"]').tooltip();
$(document).ready(function(){
  $("#taxonInput").on("keyup", function() {
    var value = $(this).val().toLowerCase();
    $("#taxonListGroup li").filter(function() {
      $(this).toggle($(this).text().toLowerCase().indexOf(value) > -1)
    });
    $("#taxonListArea li").filter(function() {
      $(this).toggle($(this).text().toLowerCase().indexOf(value) > -1)
    });
  });
});