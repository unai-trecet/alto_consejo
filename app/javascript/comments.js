function updateComments() {
  const userId = document.body.dataset.currentUserId;
  const comments = document.querySelectorAll('[data-user-id]');

  comments.forEach((comment) => {
    if (comment.dataset.userId === userId) {
      let commentActions = comment.querySelector('.comment-actions');
      commentActions.classList.remove('d-none');
    }

    // const heartIcon = comment.querySelector('.bi-heart');
    // if (comment.dataset.voted === 'true') {
    //   console.log('voted');
    //   heartIcon.classList.remove('bi-heart');
    //   heartIcon.classList.add('bi-heart-fill', 'text-danger');
    // } else {
    //   console.log('not voted');
    //   heartIcon.classList.remove('bi-heart-fill', 'text-danger');
    //   heartIcon.classList.add('bi-heart');
    // }
  });
}

document.addEventListener('DOMContentLoaded', updateComments);
document.addEventListener('turbolinks:load', updateComments);