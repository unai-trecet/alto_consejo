# frozen_string_literal: true

class DropUserTable < ActiveRecord::Migration[6.1]
  def change
    drop_table :users
  end
end
