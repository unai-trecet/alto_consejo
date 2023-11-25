// app/assets/javascripts/friendships.js
export function initializeFriendships() {
  $(function() {
    $('#confirmationForm').on('ajax:success', function(event) {
      var detail = event.detail;
      var data = detail[0], status = detail[1], xhr = detail[2];
      // Close the modal
      $('#confirmationModal').modal('hide');
      // Show a success message
      showAlert(data.message, 'success');
    }).on('ajax:error', function(event) {
      var detail = event.detail;
      var data = detail[0], status = detail[1], xhr = detail[2];
      // Show an error message
      showAlert(data.message, 'danger');
    });
  });
}

function showAlert(message, type) {
  var alertHTML = `
    <div class="alert alert-${type} alert-dismissible fade show" role="alert">
      ${message}
      <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
  `;
  $('#alert-container').append(alertHTML);
}