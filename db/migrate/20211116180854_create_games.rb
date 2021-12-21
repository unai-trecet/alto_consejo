# frozen_string_literal: true

class CreateGames < ActiveRecord::Migration[6.1]
  def change
    create_table :games do |t|
      t.string :name
      t.string :description
      t.string :author
      t.references :user, foreign_key: true
      t.references :admin, foreign_key: true
      t.text :bbg_link
      t.text :image

      t.timestamps
    end
  end
end
