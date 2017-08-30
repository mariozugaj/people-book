# Destroy all existing data
print 'Destroying existing models...'

Rails.application.eager_load!
ApplicationRecord.descendants.each(&:destroy_all)

puts 'done!'

# Multiplier constant

MULTIPLIER = 15

# Users

print 'Creating users...'

# Create user profiles with about field as a quote from API
RELATIONSHIP_OPTIONS = ['Single',
                        'In a relationship',
                        'Engaged',
                        'Married',
                        'In a civil partnership',
                        'In a domestic partnership',
                        'In an open relationship',
                        'It\'s complicated',
                        'Separated',
                        'Divorced',
                        'Widowed'].freeze

require 'rest-client'

# Get quote from Mashape and parse it
QUOTES = Array.new(MULTIPLIER) do
  JSON.parse(RestClient.get('https://andruxnet-random-famous-quotes.p.mashape.com/?cat=famous&count=1',
                            'X-Mashape-Key' => Figaro.env.MASHAPE_KEY,
                            'Accept' => 'application/json')
      .body)['quote']
end

PROFILES = Array.new(MULTIPLIER) do |idx|
  {
    birthday: Faker::Date.between(60.years.ago, 13.years.ago),
    education: Faker::University.name,
    hometown: Faker::Address.city,
    profession: Faker::Job.title,
    company: Faker::Company.name,
    relationship_status: RELATIONSHIP_OPTIONS[rand(9)],
    phone_number: Faker::PhoneNumber.cell_phone,
    about: QUOTES[idx]
  }
end

USERS = Array.new(MULTIPLIER) do |idx|
  {
    name: Faker::Name.name,
    email: "user_#{idx}@example.com",
    password: 'password',
    profile: PROFILES[idx]
  }
end

USERS.each do |user|
  new_user = User.new(name: user[:name],
                      email: user[:email],
                      password: user[:password])
  new_user.build_profile(user[:profile])
  new_user.save!
end

puts "#{User.count} created!"

# Create friendships

print 'Creating friendships...'

FRIENDSHIPS = User.pluck(:id)
                  .repeated_combination(2)
                  .reject { |combination| combination[0] == combination[1] }
                  .sample((MULTIPLIER**2) * 0.7)
                  .map do |combination|
                    {
                      user_id: combination[0],
                      friend_id: combination[1]
                    }
                  end

FRIENDSHIPS.each do |friendship|
  User.find(friendship[:user_id])
      .friend_request(User.find(friendship[:friend_id]))
end

# Accept random no of friend requests
friendship_count = Friendship.count / 2

FRIENDSHIPS.sample(friendship_count * 0.7)
           .each do |friendship|
             User.find(friendship[:friend_id])
                 .accept_request(User.find(friendship[:user_id]))
           end

puts "#{Friendship.where(status: 2).count} created!"

# Create 3 status updates for each user, pulled as articles from Wikipedia

require 'wikipedia'

print 'Creating status updates...'

User.all.each do |user|
  3.times do
    status_update_text = ''
    status_update_image = ''

    loop do
      article = Wikipedia.find_random
      if !article.summary.nil? &&
         (!article.images.nil? && !article.image_urls.nil?) &&
         (article.summary.length > 1000 && article.summary.length < 3000)

        status_update_text = "#{article.title}\n\n#{article.summary}\n\nRead"\
                             " more at <a href='#{article.fullurl}'>Wikipedia</a>"
        status_update_image = article.image_urls
                                     .grep(/\.jpg|\.png|\.jpeg|\.gif/)
                                     .sample
      end
      break if !article.summary.nil? &&
               (!article.images.nil? && !article.image_urls.nil?) &&
               (article.summary.length > 1000 && article.summary.length < 3000)
    end

    user.status_updates.create!(text: status_update_text,
                                remote_image_url: status_update_image)
  end
end

puts "#{StatusUpdate.count} created!"

# Create default photo albums + highlights album with 5 random images and
# update profile avatar and cover photo + put images into albums

print 'Creating photo albums...'

User.all.each do |user|
  avatars = PhotoAlbum.create(author: user, name: 'Avatars')
  cover_photos = PhotoAlbum.create(author: user, name: 'Cover photos')
  highlights = PhotoAlbum.create(author: user, name: 'Highlights')

  avatars.images.create(remote_image_url: Faker::LoremPixel.image('780x720', false))
  cover_photos.images.create(remote_image_url: Faker::LoremPixel.image('1260x630', false))

  user.profile.update avatar: avatars.reload.images.first.image,
                      cover_photo: cover_photos.reload.images.first.image

  5.times do
    image = Faker::LoremPixel.image('1280x720')
    highlights.images.create(remote_image_url: image,
                             description: Faker::Hacker.say_something_smart)
  end
end

puts 'done!'

# Create status updates and image comments

print 'Creating comments...'

COMMENTABLES = [Image, StatusUpdate].freeze

COMMENTABLES.each do |commentable|
  random_commentables = commentable.all.sample(commentable.count * 0.7)
  random_commentables.each do |commentable_object|
    random_users =
      User.all
          .select { |user| commentable_object.author.friends.include? user }
          .sample(MULTIPLIER * 0.5)

    random_users.each do |user|
      commentable_object
        .comments
        .create(author: user, text: Faker::Lorem.paragraph(2, false, 4))
    end
  end
end

puts "#{Comment.count} created!"

# Create status update, comment and image likes

print 'Creating likes...'

LIKEABLES = [Image, StatusUpdate, Comment].freeze

LIKEABLES.each do |likeable|
  random_likeables = likeable.all.sample(likeable.count * 0.6)

  random_likeables.each do |likeable_object|
    random_users = User.all
                       .sample(rand(1..(MULTIPLIER * 0.5)))
                       .select { |user| likeable_object.author.friends.include? user }

    random_users.each do |user|
      likeable_object.likes.create(user: user)
    end
  end
end

puts "#{Like.count} created!"

CONVERSATIONS = User.pluck(:id)
                    .repeated_combination(2)
                    .reject { |combination| combination[0] == combination[1] }
                    .select { |combination| User.find(combination[0]).friends_with? User.find(combination[1]) }
                    .sample((MULTIPLIER**2) * 0.7)
                    .map do |combination|
                      {
                        sender_id: combination[0],
                        receiver_id: combination[1]
                      }
                    end

CONVERSATIONS.each do |conversation|
  Conversation.create!(conversation)
end

Conversation.all.each do |conversation|
  5.times do
    Message.create!(user: conversation.sender,
                    conversation: conversation,
                    body: Faker::Hacker.say_something_smart)
    Message.create!(user: conversation.receiver,
                    conversation: conversation,
                    body: Faker::Hacker.say_something_smart)
  end
end

puts "#{Conversation.count} created!"

puts 'Done with everything!'
