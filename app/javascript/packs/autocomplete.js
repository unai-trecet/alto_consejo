import 'js-autocomplete/auto-complete.css';
import autocomplete from 'js-autocomplete';

const renderItem = function (item) {
  return `<div class="autocomplete-suggestion" data-val="${item.name}"><span>${item.name}</span></div>`
};

const autocompleteSearch = function() {
  const names = JSON.parse(document.getElementById('search-data').dataset.names)
  var searchInput = document.getElementById('game_name');

  if (names || searchInput) {
    new autocomplete({
      selector: searchInput,
      minChars: 3,
      source: function(term, suggest){
        $.getJSON('/autocomplete',
          { q: term },
          function(data) {
            return data;
        }).then((data) => {
          const matches = []
          data.names.forEach((name) => {
            matches.push({ name: name });
          });
          suggest(matches)
        });
      },
      renderItem: renderItem,
    });
  }
};

export { autocompleteSearch };
