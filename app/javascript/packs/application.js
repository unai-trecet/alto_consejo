require("@hotwired/turbo-rails")
import Rails from "@rails/ujs";
require("@rails/activestorage").start()

window.Rails = Rails

import 'bootstrap'


require("trix")
require("@rails/actiontext")
import "controllers"