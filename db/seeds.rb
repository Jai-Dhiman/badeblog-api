user = User.new(
  name: 'PR Dhiman',
  email: 'prdhiman@gmail.com',
  password: 'kalakunj101',
  password_confirmation: 'kalakunj101',
  role: 'admin'
)
user.save!

categories = [
  Category.new(name: 'Essays'),
  Category.new(name: 'Articles'),
  Category.new(name: 'Short Stories'),
  Category.new(name: 'Poems'),
  Category.new(name: 'Plays'),
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