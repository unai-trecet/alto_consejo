$(function () {
  $("#game_name").autocomplete({
    minLength: 3,
    source: function (request, response) {
      $.getJSON("/autocomplete",
        { q: request.term },
        response);
    },
  });
});

