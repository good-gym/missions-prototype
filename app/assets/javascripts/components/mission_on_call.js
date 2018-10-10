$(document).ready(function($) {
  $(".mission-on-call input[type=checkbox").on("change", function(e) {
    if (this.checked == true) {
      $(".mission-on-call").toggleClass("alert-success alert-info");
      $(".mission-on-call__label").text("You will receive alerts about missions near");
    } else {
      $(this).closest(".mission-on-call").toggleClass("alert-success alert-info");
      $(".mission-on-call__label").text("Turn on to get alerts near");
    }
  });
});
