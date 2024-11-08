# admin = User.find_by(email: 'admin@gmail.com')

# unless admin
#   User.create!(
#     name: 'admin',
#     email: 'admin@gmail.com',
#     password: 'password',
#     password_confirmation: 'password',
#     role: 'admin'
#   )
#   puts 'Admin user created successfully!'
# else
#   puts 'Admin user already exists'
# end

# categories = Category.create!([
#   { name: 'Stories' },
#   { name: 'Articles' },
#   { name: 'Blogs' }
# ])

story = Story.new(
  title: 'Sample Story 1',
  content: 'This is a sample 1',
  status: 'published',
  # category: categories.first,
  user_id: 1
)

story.save!

