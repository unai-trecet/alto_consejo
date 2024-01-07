class RemoveAdminColumnFromAdmin < ActiveRecord::Migration[7.1]
  def change
    remove_column :games, :admin_id
  end
end
