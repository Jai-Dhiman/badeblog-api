admin = User.find_by(email: 'admin@gmail.com')

unless admin
  User.create!(
    name: 'admin',
    email: 'admin@gmail.com',
    password: 'password',
    password_confirmation: 'password',
    role: 'admin'
  )
  puts 'Admin user created successfully!'
else
  puts 'Admin user already exists'
end