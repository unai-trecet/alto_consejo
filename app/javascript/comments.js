function updateComments() {
  const userId = document.body.dataset.currentUserId;
  const comments = document.querySelectorAll('[data-user-id]');

  comments.forEach((comment) => {
    if (comment.dataset.userId === userId) {
      let commentActions = comment.querySelector('.comment-actions');
      commentActions.classList.remove('d-none');
    }
  });
}

document.addEventListener('DOMContentLoaded', updateComments);
document.addEventListener('turbolinks:load', updateComments);