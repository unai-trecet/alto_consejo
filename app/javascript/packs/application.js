// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require.context('./img', true);

import Rails from "@rails/ujs";
import Turbolinks from "turbolinks";
import * as ActiveStorage from "@rails/activestorage";
import "channels";

import "bootstrap";
import 'bootstrap-icons/font/bootstrap-icons.css';

import "@fortawesome/fontawesome-free/js/all";
import "@fortawesome/fontawesome-free/css/all";

import "./styles/application.scss";

import('./sidebar/jquery-3.3.1.min');
import('./sidebar/jquery-migrate-3.0.0.min');
import('./sidebar/jquery.backstretch');
import('./sidebar/jquery.backstretch.min');
import('./sidebar/jquery.mCustomScrollbar.concat.min');
import('./sidebar/jquery.waypoints');
import('./sidebar/jquery.waypoints.min');
import('./sidebar/scripts_index');
import('./sidebar/scripts');
import('./sidebar/waypoints');
import('./sidebar/waypoints.min');
import('./sidebar/wow');
import('./sidebar/wow.min');

Rails.start()
Turbolinks.start()
ActiveStorage.start()
