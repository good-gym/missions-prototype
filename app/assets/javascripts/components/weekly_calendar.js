$(document).on('ready turbolinks:load', function() {
  $('.weekly-calendar button[data-day]').on('click', function(e) {
    var day = $(this).data('day');
    var days = $('.weekly-calendar input[type=checkbox][data-day='+day+']');
    console.log(days);
    var daysChecked = days.map(function(e) { return this.checked; });
    var anyChecked = $.makeArray(daysChecked).includes(true);
    if (anyChecked) {
      days.prop('checked', false);
    } else {
      days.prop('checked', true);
    }
  });
  $('.weekly-calendar button[data-time]').on('click', function(e) {
    var time = $(this).data('time');
    var times = $('.weekly-calendar input[type=checkbox][data-time="'+time+'"]');
    var timesChecked = times.map(function(e) { return this.checked; });
    var anyChecked = $.makeArray(timesChecked).includes(true);
    if (anyChecked) {
      times.prop('checked', false);
    } else {
      times.prop('checked', true);
    }
  });
});
