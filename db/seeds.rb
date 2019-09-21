require 'factory_bot_rails'

FactoryBot.create(:user, email: "example@mail.com", password: 'foobar', first_name: 'Demo', last_name: 'User')

# users
11.times.each { |i| FactoryBot.create(:user) }

# posts
20.times.each { |i| FactoryBot.create(:post, user: User.all.sample) }

# comments
50.times.each { |i| FactoryBot.create(:comment, post: Post.all.sample, user: User.all.sample) }

# likes
60.times.each { |i| FactoryBot.create(:like, likeable: (Post.all + Comment.all).sample ,user: User.all.sample) }

# friendships
User.all[1..3].each { |user| user.friend_request(User.first) }
User.all[4..6].each { |friend| User.first.friend_request(friend) }
User.all[7..9].each do |user|
  user.friend_request(User.first)
  User.first.accept_request(user)
end