class SimplifyDatabaseStructure < ActiveRecord::Migration[7.1]
  def change
    unless column_exists?(:stories, :user_id)
      add_column :stories, :user_id, :bigint
    end

    unless column_exists?(:stories, :category_id)
      add_column :stories, :category_id, :bigint
    end

    unless foreign_key_exists?(:stories, :users)
      add_foreign_key :stories, :users
    end
    
    unless foreign_key_exists?(:stories, :categories)
      add_foreign_key :stories, :categories
    end

    unless index_exists?(:stories, :user_id)
      add_index :stories, :user_id
    end

    unless index_exists?(:stories, :category_id)
      add_index :stories, :category_id
    end

    remove_index :active_storage_attachments, name: "index_active_storage_attachments_uniqueness", if_exists: true
    remove_index :active_storage_variant_records, name: "index_active_storage_variant_records_uniqueness", if_exists: true

    add_index :users, :email, unique: true, if_not_exists: true
    add_index :stories, :deleted_at, if_not_exists: true
  end

  private

  def foreign_key_exists?(from_table, to_table)
    foreign_keys(from_table).any? { |k| k.to_table.to_s == to_table.to_s }
  end

  def column_exists?(table, column)
    ActiveRecord::Base.connection.column_exists?(table, column)
  end
end