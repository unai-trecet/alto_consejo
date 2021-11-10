// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require.context('./images', true);

import Rails from "@rails/ujs";
import Turbolinks from "turbolinks";
import * as ActiveStorage from "@rails/activestorage";
import "channels";

window.bootstrap = require("bootstrap");
import 'bootstrap-icons/font/bootstrap-icons.css';

import "@fortawesome/fontawesome-free/css/all";

import "./styles/application.scss";

import('./admin');


Rails.start()
Turbolinks.start()
ActiveStorage.start()
