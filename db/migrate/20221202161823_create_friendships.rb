class CreateFriendships < ActiveRecord::Migration[7.0]
  def change
    create_table :friendships do |t|
      t.integer :followed_id, foreign_key: true
      t.integer :follower_id, foreign_key: true

      t.timestamps
    end
  end
end
