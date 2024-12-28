class Unsubscribe < ActiveRecord::Migration[7.1]
  def change
    add_column :subscribers, :unsubscribe_token, :string
    add_index :subscribers, :unsubscribe_token, unique: true
  end
end
