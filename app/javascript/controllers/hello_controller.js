// src/controllers/hello_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ 'form' ]

  greet(event) {
    event.preventDefault()
    this.formTarget.classList.toggle("d-none")
    console.log(`Hello!`)
  }

  get name() {
    return this.nameTarget.value
  }
}
