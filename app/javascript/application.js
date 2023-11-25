// Entry point for the build script in your package.json

import Rails from "@rails/ujs";
import "./jquery.js"
import "@hotwired/turbo-rails"
import "@rails/actiontext"
import "trix"
import * as ActiveStorage from "@rails/activestorage";
import * as bootstrap from "bootstrap"

import "./customFlatpickr"
import "./autocompleteUsername"
import "./channels";
import "./admin";

import { initializeFriendships } from "./friendships";
initializeFriendships();

Rails.start()
ActiveStorage.start()
import "./controllers"