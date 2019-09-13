require 'factory_bot_rails'

FactoryBot.create(:user, email: "example@mail.com", password: 'foobar')

# users
5.times.each { |i| FactoryBot.create(:user) }

# posts
5.times.each { |i| FactoryBot.create(:post) }

# comments
5.times.each { |i| FactoryBot.create(:comment) }

# likes
5.times.each { |i| FactoryBot.create(:like) }

User.all.each { |user| user.friendships.create(friend_id: User.first.id) }
