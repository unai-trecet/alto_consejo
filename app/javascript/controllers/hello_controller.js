import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="comment-reply"
export default class extends Controller {
  connect() {
    this.element.textContent = "HEllo World"
  }
}
