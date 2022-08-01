# frozen_string_literal: true

class AddIndexToMatchParticipant < ActiveRecord::Migration[6.1]
  def change
    add_index :match_participants, %i[user_id match_id], unique: true
  end
end
