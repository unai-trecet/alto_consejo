class AlterFriendshipsTable < ActiveRecord::Migration[7.0]
  def change
    remove_column :friendships, :followed_id
    remove_column :friendships, :follower_id

    add_reference :friendships, :user
    add_column :friendships, :friend_id, :integer, null: false, foreign_key: true
    add_column :friendships, :accepted_at, :datetime
  end
end
