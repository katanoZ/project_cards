class RenameFromUserIdToOwnerIdOnUsers < ActiveRecord::Migration[5.2]
  def change
    rename_column :projects, :user_id, :owner_id
  end
end
