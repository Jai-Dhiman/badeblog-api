class AddRoleToUsersAndSoftDeleteToStories < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :role, :string, default: 'user'
    add_column :stories, :deleted_at, :datetime
    add_index :stories, :deleted_at
  end
end
