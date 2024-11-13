class StorySerializer < ActiveModel::Serializer
  attributes :id, :title, :content, :status, :category_id, :user_id, :created_at, :updated_at

  has_one :category
  has_one :user

  def content
    object.content.to_s if object.content.present?
  end
end