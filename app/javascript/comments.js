document.addEventListener('DOMContentLoaded', () => {
  const userId = document.body.dataset.currentUserId;
  const comments = document.querySelectorAll('[data-user-id]');
  console.log(userId);

  comments.forEach((comment) => {
    console.log(comment.dataset.userId);
    if (comment.dataset.userId === userId) {
      comment.querySelector('.comment-actions').classList.remove('d-none');
    }
  });
});