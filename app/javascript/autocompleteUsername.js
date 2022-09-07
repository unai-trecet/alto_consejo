document.addEventListener("autocomplete.change", (event) => {
  const selectedUser = document.getElementById("selected_user")
  const invitedUsers = document.getElementById("invited_users")

  const selected = event.detail.value
  const alreadyInvited = invitedUsers.value

  if (!invitedUsers.value.includes(selected)) {
    invitedUsers.value = alreadyInvited +  " " + selected
  }
  selectedUser.value = ''

})

