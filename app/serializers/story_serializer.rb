class StorySerializer < ActiveModel::Serializer
  attributes :id, :title, :content, :status, :category_id, :user_id, :created_at, :updated_at

  has_one :category
  has_one :user

  def content
    return nil unless object.content.present?
    
    if object.content.to_s.include?('class="trix-content"')
      object.content.to_s
    else
      "<div class=\"trix-content\">#{object.content.to_s}</div>"
    end
  end
end