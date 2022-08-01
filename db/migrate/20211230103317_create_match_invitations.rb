# frozen_string_literal: true

class CreateMatchInvitations < ActiveRecord::Migration[6.1]
  def change
    create_table :match_invitations do |t|
      t.references :user, null: false, foreign_key: true
      t.references :match, null: false, foreign_key: true

      t.timestamps
    end

    add_index :match_invitations, %i[user_id match_id], unique: true
  end
end
