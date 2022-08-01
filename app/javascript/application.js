// Entry point for the build script in your package.json

// require.context('./images', true);
// import "./images"
console.log('BRASAS 1');


import Rails from "@rails/ujs";
import "./jquery.js"
import "@hotwired/turbo-rails"
import "@rails/actiontext"
import "trix"
import * as ActiveStorage from "@rails/activestorage";
import "./channels";
// import "jquery";
// import "jquery-ui";

window.bootstrap = require("bootstrap");
import 'bootstrap-icons/font/bootstrap-icons.css';
import "@fortawesome/fontawesome-free/css/all";

import('./admin');

import './autocompleteUsername';
import './autocompleteGameName';

require("flatpickr")

$("#match_start_at, #match_end_at").flatpickr({
  enableTime: true,
  dateFormat: "F, d Y H:i"
});

console.log('BRASAS 2');

Rails.start()
ActiveStorage.start()
import "./controllers"
import * as bootstrap from "bootstrap"
