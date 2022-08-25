const selectedUser = document.getElementById("selected-user")
const invitedUsers = document.getElementById("invited-users")

document.addEventListener("autocomplete.change", (event) => {
  const selected = "@" + event.detail.value
  const alreadyInvited = invitedUsers.value

  invitedUsers.value = alreadyInvited + selected + " "
  selectedUser.value = ''
})