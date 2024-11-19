class AddPublishedAtToStories < ActiveRecord::Migration[7.1]
  def change
    add_column :stories, :published_at, :datetime
  end
end
