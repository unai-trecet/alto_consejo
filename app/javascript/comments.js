function updateComments() {
  const userId = document.body.dataset.currentUserId;
  const comments = document.querySelectorAll('[data-user-id]');

  console.log(`userId: ${userId}`);

  comments.forEach((comment) => {
    console.log(`comment.dataset.userId: ${comment.dataset.userId}`);

    if (comment.dataset.userId === userId) {
      let commentActions = comment.querySelector('.comment-actions');
      commentActions.classList.remove('d-none');
    }
  });
}

document.addEventListener('DOMContentLoaded', updateComments);
document.addEventListener('turbolinks:load', updateComments);
document.addEventListener('DOMContentLoaded', () => {
  const observer = new MutationObserver(updateComments);

  observer.observe(document.body, {
    childList: true,
    subtree: true
  });
});