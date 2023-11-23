class FriendshipsCreationManager
  def initialize(user_id:, friend_id:)
    @user = User.find(user_id)
    @friend = User.find(friend_id)
  end

  def call
    return existing_friendship_result if existing_friendship?

    ActiveRecord::Base.transaction do
      create_friendship
      send_notification
    end

    Result.new(success: true, data: @friendship.to_json)
  rescue StandardError => e
    handle_error(e)
  end

  private

  def existing_friendship?
    Friendship.already_exists?(user_id: @user.id, friend_id: @friend.id)
  end

  def existing_friendship_result
    Result.new(success: false,
               error: "A Frienship for user_id: #{@user.id}}, friend_id: #{@friend.id}}, already exists")
  end

  def create_friendship
    @friendship = Friendship.create(user: @user, friend: @friend)
  end

  def send_notification
    FriendshipRequestNotification
      .with(friendship: @friendship)
      .deliver_later(@friend)
  end

  def handle_error(e)
    msg = "Something went wrong creating a Friendship: #{e.message}"
    Rails.logger.error(msg)
    Result.new(success: false, error: msg)
  end
end
