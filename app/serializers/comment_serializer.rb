class CommentSerializer < ActiveModel::Serializer
  attributes :id, :content, :created_at, :updated_at, :user_info

  def user_info
    {
      id: object.user.id,
      name: object.user.name
    }
  end
end