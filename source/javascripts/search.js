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
        console.info('Downloaded Search JSON.');
        setupSearch(data);
      },
    });
  });

  function setupSearch(lunrData) {
    console.info('Creating search index.');

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

          $searchResults.append(
            '<li class="result">' +
              '<a href="' + page.url + '">' +
                page.title +
              '</a>' +
            '</li>'
          );
        });
      }
    }).keyup();
  }

  function showResultCount(count) {
    var resultString = count === 1 ? data.result : data.results;
    $searchResults.append('<h3>' + count + ' ' + resultString + '</h3>');
  }
}(jQuery));
