// Entry point for the build script in your package.json

// require.context('./images', true);
// import "./images"

import Rails from "@rails/ujs";
import "./jquery.js"
import "@hotwired/turbo-rails"
import "@rails/actiontext"
import "trix"
import * as ActiveStorage from "@rails/activestorage";

import "./channels";
import "./admin";
import "./autocompleteUsername"
import "./customFlatpickr"


Rails.start()
ActiveStorage.start()
import "./controllers"
import * as bootstrap from "bootstrap"
