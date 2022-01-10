// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require.context('./images', true);

import Rails from "@rails/ujs";
import * as ActiveStorage from "@rails/activestorage";
import "channels";
import "jquery";
import "jquery-ui";
import '@hotwired/turbo-rails';

window.bootstrap = require("bootstrap");
import 'bootstrap-icons/font/bootstrap-icons.css';
import "@fortawesome/fontawesome-free/css/all";

import "./styles/application.scss";

import('./admin');

import './autocompleteUsername';
import './autocompleteGameName';

require("flatpickr")

$("#match_start_at, #match_end_at").flatpickr({
  enableTime: true,
  dateFormat: "F, d Y H:i"
});

Rails.start()
ActiveStorage.start()

import "controllers"

require("trix")
require("@rails/actiontext")