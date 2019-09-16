require 'factory_bot_rails'

FactoryBot.create(:user, email: "example@mail.com", password: 'foobar', first_name: 'demo', last_name: 'user')

# users
11.times.each { |i| FactoryBot.create(:user) }

# posts
20.times.each { |i| FactoryBot.create(:post, user: User.all.sample) }

# comments
50.times.each { |i| FactoryBot.create(:comment, post: Post.all.sample, user: User.all.sample) }

# likes
60.times.each { |i| FactoryBot.create(:like, likeable: (Post.all + Comment.all).sample ,user: User.all.sample) }

# friendships
User.all[1..3].each { |user| user.friendships.create(friend: User.first) }
User.all[4..6].each { |user| user.friendships.create(friend: User.first, confirmed: true) }
User.all[7..9].each { |friend| User.first.friendships.create(friend: friend) }
