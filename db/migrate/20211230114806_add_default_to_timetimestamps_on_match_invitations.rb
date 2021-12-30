class AddDefaultToTimetimestampsOnMatchInvitations < ActiveRecord::Migration[6.1]
  def change
    change_column :match_invitations, :created_at, :datetime, null: false, default: -> { "CURRENT_TIMESTAMP" }
    change_column :match_invitations, :updated_at, :datetime, null: false, default: -> { "CURRENT_TIMESTAMP" }
  end
end
