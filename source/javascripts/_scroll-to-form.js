$(function () {
  'use strict';

  $('#cta-button').click(function () {
    var $target = $(this.hash);

    $.scrollTo($target, 400, {
      onAfter: function () {
        $target.find('input, textarea, select')
        .not('input[type=hidden],input[type=button],input[type=submit],button')
        .filter(':enabled:visible:first')
        .focus();
      },
    });

    return false;
  });
});
