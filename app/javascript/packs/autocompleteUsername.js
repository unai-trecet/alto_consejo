var usernames = [];

$('#match_usernames').autocomplete({
  minLength: 3,
  source: function (request, response) {
    var term = request.term;

    // substring of new string (only when a space is in string)
    if (term.indexOf(' ') > 0) {
      var index = term.lastIndexOf(' ');
      term = term.substring(index + 1);
    }
    fetchUsernames(term);
    // regex to match string entered with start of suggestion strings
    var re = $.ui.autocomplete.escapeRegex(term);
    var matcher = new RegExp('^' + re, 'i');
    var regex_validated_array = $.grep(usernames, function (item, index) {
      return matcher.test(item);
    });
    usernames = [];
    // pass array `regex_validated_array ` to the response and 
    // `extractLast()` which takes care of the space separation

    response($.ui.autocomplete.filter(regex_validated_array,
      extractLast(term)));
  },
  focus: function () {
    return false;
  },
  select: function (event, ui) {
    var terms = split(this.value);
    terms.pop();
    var selection = '@' + ui.item.value

    if (!this.value.includes(selection)) {
      terms.push(selection);
      terms.push('');
    }
    this.value = terms.join(' ');

    return false;
  }
});

function split(val) {
  return val.split(' ');
}

function extractLast(term) {
  return split(term).pop();
}

function fetchUsernames(term) {
  $.getJSON('/users',
    { q: term },
    function (data) {
      return data;
    }).then((data) => {
      data.forEach((user) => {
        usernames.push(user.username);
      });
    });
}
