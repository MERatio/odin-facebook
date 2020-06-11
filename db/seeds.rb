# Users
User.create!(first_name: 'John',
             last_name: 'Doe',
             email: 'johndoe@example.com',
             password: 'foobar',
             password_confirmation: 'foobar')

User.create!(first_name: 'Jane',
             last_name: 'Doe',
             email: 'janedoe@example.com',
             password: 'foobar',
             password_confirmation: 'foobar')

50.times do |n|
  first_name = Faker::Name.first_name
  last_name = Faker::Name.last_name
  email = "user#{n+3}@example.com".downcase
  password = 'foobar'
  User.create!(first_name: first_name,
               last_name: last_name,
               email: email,
               password: password,
               password_confirmation: password)
end

# Friending relashionships
users = User.all
user = users.first
other_users = users[2..51]
other_users.each do |other_user| 
  user.send_friend_request_to(other_user)
  other_user.accept_friend_request(user)
end

# Posts
50.times do 
  content = Faker::Lorem.sentence(word_count: 100)
  users.take(5).each { |user| user.posts.create!(content: content) }
end