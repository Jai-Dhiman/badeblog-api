user = User.new(
  name: 'PR Dhiman',
  email: 'prdhiman@gmail.com',
  password: 'kalakunj101',
  password_confirmation: 'kalakunj101',
  role: 'admin'
)
user.save!

categories = [
  Category.new(name: 'Essay'),
  Category.new(name: 'Article'),
  Category.new(name: 'Short Story'),
  Category.new(name: 'Poem'),
  Category.new(name: 'Play'),
  Category.new(name: 'Other')
]

categories.each(&:save!)

story = Story.new(
  title: 'Sample Story',
  content: 'This is a sample',
  status: 'published',
  category: categories.first,
  user_id: 1
)
story.save!