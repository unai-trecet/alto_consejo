class FriendshipCreationManager

  def initialize(:user_id, :friend_id)
    @user = User.find(user_id)
    @friend = User.find(friend_id)
  end

  def call
    create_friendship
    send_notification
    
    @frienship
  rescue StandardError => e
    msg = "Something went wrong creating a Friendship: #{e.message}"
    Rails.logger.error(msg)
  end

  private

  def create_friendship
    @frienship = Friendship.create(user: @user, friend: @friend)
  end

  def send_notification
    FriendshipRequestNotification.
      with(friendship: @friendship).
      deliver_later(@friend)
  end

end
