$(document).ready(function($) {
  $(".mission-on-call input[type=checkbox").on("change", function(e) {
    if (this.checked == true) {
      $(this).closest(".mission-on-call").toggleClass("mission-on-call--enabled mission-on-call--disabled");
    } else {
      $(this).closest(".mission-on-call").toggleClass("mission-on-call--enabled mission-on-call--disabled");
    }
  });
});
