$(document).ready(function($) {
  $(".availability__time-slot-delete").on("click", function(e) {
    $(this).closest(".availability__time-slot").remove();
  });
});
