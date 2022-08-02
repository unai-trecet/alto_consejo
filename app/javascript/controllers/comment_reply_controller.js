import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="comment-reply"
export default class extends Controller {
  static targets = [ "form" ]
  toggle(event) {
    event.preventDefault()
    this.formTarget.classList.toggle("d-none")
    console.log("MAL FATAL")
  }

  greeet() {
    console.log("MAL FATAL 3")
  }
}
