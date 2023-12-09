import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["actions"]

  connect() {
    this.updateComments();
    this.observer = new MutationObserver(() => this.updateComments());

    this.observer.observe(this.element, {
      childList: true,
      subtree: true
    });
  }

  disconnect() {
    this.observer.disconnect();
  }

  updateComments() {
    const userId = document.body.dataset.currentUserId;
    const commentUserId = this.data.get('userId');
  
    if (userId === commentUserId) {
      this.actionsTarget.classList.remove('d-none');
    }
  }
}