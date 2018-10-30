$(document).on('ready turbolinks:load', function() {
  $('.mission-on-call input[type=checkbox]').on('change', function(e) {
    $(this)
      .closest('.mission-on-call')
      .toggleClass('mission-on-call--enabled mission-on-call--disabled text-primary');

    var text = (this.checked === true) ? "Enabled" : "Disabled";
    $(this).closest('.mission-on-call')
      .find('span.badge')
      .toggleClass('badge-success badge-secondary')
      .text(text);
  });
});
