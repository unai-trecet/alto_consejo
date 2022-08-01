# frozen_string_literal: true

class AddInvitedUsersAndPublicToMatches < ActiveRecord::Migration[6.1]
  def change
    add_column :matches, :invited_users, :string, array: true, default: '{}'
    add_column :matches, :public, :boolean
  end
end
