$(document).on('ready turbolinks:load', function() {
  $('.readmore').addClass('readmore--collapsed');
  $('.readmore button').on('click', function() {
    $(this)
      .closest('.readmore')
      .toggleClass('readmore--collapsed');

    if ($(this).closest('.readmore').hasClass('readmore--collapsed')) {
      $(this).text("Read more");
    } else {
      $(this).text("Read less");
    }
  });
});
