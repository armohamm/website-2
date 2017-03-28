$(function () {
  'use strict';

  $('#cta-button').click(function () {
    var $target = $(this.hash);

    $.scrollTo($target, 400, {
      onAfter: function () {
        $target.find('input[name="name"]').focus();
      },
    });

    return false;
  });
});
