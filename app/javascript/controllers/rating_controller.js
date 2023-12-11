import { Controller } from "@hotwired/stimulus"
import Rails from "@rails/ujs"

export default class extends Controller {
  static targets = ["star"]

  connect() {
    console.log("RatingController connected")
  }

  fill(event) {
    this.starTargets.forEach((star, index) => {
      star.classList.toggle('fas', index <= event.currentTarget.dataset.rating - 1)
    })
  }

  unfill(event) {
    this.starTargets.forEach(star => {
      star.classList.remove('fas')
    })
  }


  rate(event) {
    let rating = event.currentTarget.dataset.rating
    let rateableId = event.currentTarget.dataset.rateableId
    let rateableType = event.currentTarget.dataset.rateableType

    Rails.ajax({
      url: "/ratings",
      type: "post",
      data: `rating[value]=${rating}&rating[rateable_id]=${rateableId}&rating[rateable_type]=${rateableType}`,
      success: (response) => {
        this.starTargets.forEach((star, index) => {
          star.classList.toggle('fas', index < rating)
          star.classList.toggle('far', index >= rating)
        })
        // Close the modal
        $('#ratingModal').modal('hide')
      },
      error: (error) => {
        alert('An error occurred while submitting the rating. Please try again.')
      }
    })
  }
}
