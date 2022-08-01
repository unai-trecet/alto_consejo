# frozen_string_literal: true

class CreateMatches < ActiveRecord::Migration[6.1]
  def change
    create_table :matches do |t|
      t.text :title
      t.text :description
      t.references :user, null: false, foreign_key: true
      t.references :game, null: false, foreign_key: true
      t.text :location
      t.integer :number_of_players
      t.datetime :start_at
      t.datetime :end_at

      t.timestamps
    end
  end
end
