//= require lunr.min.js
//= require lunr.stemmer.support
//= require lunr.de
//= require lunr.du

(function ($) {
  var lunrIndex = null;
  var lunrMap  = null;
  var $search;
  var $searchInput;
  var $searchResults;
  var data;

  $(function () {
    $search = $('.js-search');
    data = $search.data();
    $searchInput = $search.find('#search-input');
    $searchResults = $search.find('.search-results');

    // Download search index and then set up search.
    $.ajax({
      url: '/search.json',
      cache: true,
      method: 'GET',
      success: function (data) {
        // Callback for success: log it and set up search
        setupSearch(data);
      },
    });
  });

  function setupSearch(lunrData) {

    lunrIndex = lunr.Index.load(lunrData.index);
    lunrMap = lunrData.docs;

    $searchInput.focus();
    $('#downloading').remove();

    $searchInput.on('keyup', function () {
      $searchResults.empty();

      var query = $(this).val();

      if (query.length <= 2) { return; }

      var results = lunrIndex.search(query);

      showResultCount(results.length);

      if (results.length > 0) {
        $.each(results, function (index, result) {
          page = lunrMap[result.ref];

          var html = '<li class="result">' +
              '<h3><a href="' + page.url + '">' + page.title + '</a></h3>' +
              '<span class="result-meta">' + page.type;

          if (page.author) {
            html += '<span class="separator">–</span>' + page.author;
          }

          html += '</span><p>' +

          $.trim(page.content).substring(0, 400)
                              .split(' ').slice(0, -2).join(' ') + '...' +

          '<a href="' + page.url + '">' + data.readMore + '</a></p></li>';

          $searchResults.append(html);
        });
      }
    }).keyup();
  }

  function showResultCount(count) {
    var resultString = count === 1 ? data.result : data.results;
    $searchResults.append('<h3>' + count + ' ' + resultString + '</h3>');
  }
}(jQuery));
