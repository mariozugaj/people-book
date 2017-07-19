# Destroy all existing models
print 'Destroying existing models...'

Rails.application.eager_load!
ApplicationRecord.descendants.each(&:destroy_all)

puts 'done!'

# Multiplier constant

MULTIPLIER = 50

# Users

print 'Creating users...'

MULTIPLIER.times do |index|
  first_name = Faker::Name.first_name
  last_name = Faker::Name.last_name
  User.create!(name: "#{first_name} #{last_name}",
               email: Faker::Internet.email(first_name),
               password: Faker::Internet.password(30, 50))
end

print "#{User.count} created..."
puts 'done!'

# Create user profiles with about field as a quote from API

print 'Creating profiles...'

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

User.all.each do |user|

  # Get quote from Mashape and parse it
  response =
    RestClient.get('https://andruxnet-random-famous-quotes.p.mashape.com/?cat=famous&count=1',
      headers = {
                  'X-Mashape-Key' => Figaro.env.MASHAPE_KEY,
                  'Accept' => 'application/json'
                })
  quote = JSON.parse(response.body)['quote']

  Profile.create(user: user)

  user.reload
      .profile
      .update(birthday: Faker::Date.between(60.years.ago, 18.years.ago),
              education: Faker::University.name,
              hometown: Faker::Address.city,
              profession: Faker::Job.title,
              company: Faker::Company.name,
              relationship_status: RELATIONSHIP_OPTIONS[rand(9)],
              phone_number: Faker::PhoneNumber.cell_phone,
              about: quote)
end

print "#{Profile.count} created..."
puts 'done!'

# Create random no of friend requests to random users from each user

print 'Creating friend requests...'

User.all.each do |user|
  # Get random no of user ids which are != user id and
  # from which user hasn't received friend request
  random_friend_ids = User.pluck(:id)
                          .reject { |id| id == user.id }
                          .reject do |id|
                            user.received_friend_requests
                                .map(&:user_id)
                                .include? id
                          end
                          .sample(rand((MULTIPLIER * 0.5)..MULTIPLIER))

  # Create friend request for each random user id
  random_friend_ids.each do |id|
    user.sent_friend_requests.create(friend: User.find(id))
  end
end
print "#{Friendship.count} created..."
puts 'done!'

# Accept random no of friend requests

print 'Accepting friend requests...'

Friendship.all
          .sample(rand((Friendship.count * 0.5)..Friendship.count))
          .each { |friendship| friendship.update(accepted: true) }

print "#{Friendship.where(accepted: true).count} accepted..."
puts 'done!'

# Create 3..10 status updates for each user, pulled as articles from Wikipedia

require 'wikipedia'

print 'Creating status updates...'

User.all.each do |user|
  rand(3..10).times do
    # Get random article from Wikipedia
    status_update_text = ''
    article_image = ''

    loop do
      article = Wikipedia.find_random
      if !article.summary.nil? && !article.images.nil? && (article.summary.size > 1000)
        status_update_text = "#{article.title}\n\n#{article.summary}\n\nRead more <a href='#{article.fullurl}'>here</a>"
        article_image = article.image_urls.shuffle.first
      end
      break if !article.summary.nil? && !article.images.nil? && (article.summary.size > 1000)
    end

    user.status_updates.create(text: status_update_text,
                               remote_image_url: article_image)
  end
end

print "#{StatusUpdate.count} created..."
puts 'done!'

# Create default photo albums + highlights album with 5 random images and
# update profile avatar and cover photo + put images into albums

print 'Creating photo albums...'

User.all.each do |user|
  avatars = PhotoAlbum.create(author: user, name: 'Avatars')
  cover_photos = PhotoAlbum.create(author: user, name: 'Cover photos')
  highlights = PhotoAlbum.create(author: user, name: 'Highlights')

  avatars.images.create(remote_image_url: Faker::LoremPixel.image('780x720', false, 'nightlife'))
  cover_photos.images.create(remote_image_url: Faker::LoremPixel.image('1260x630', false, 'nature'))

  user.profile.update avatar: avatars.reload.images.first.image,
                      cover_photo: cover_photos.reload.images.first.image

  5.times do
    image = Faker::LoremPixel.image('1280x720')
    highlights.images.create(remote_image_url: image)
  end
end

puts 'done!'

# Create status updates and image comments

print 'Creating comments...'

commentables = %w[Image StatusUpdate]

commentables.each do |commentable|
  random_commentables = commentable.constantize
                                   .all
                                   .sample(commentable.constantize
                                                           .count * 0.6)
  random_commentables.each do |commentable_object|
    random_users =
      User.all
          .select { |user| commentable_object.author.friends.include? user }
          .sample(MULTIPLIER * 0.4)

    random_users.each do |user|
      commentable_object
        .comments
        .create(author: user, text: Faker::Lorem.paragraph(2, false, 4))
    end
  end
end

print "#{Comment.count} created..."
puts 'done!'

# Create status update, comment and image likes
print 'Creating likes...'

likeables = %w[Image StatusUpdate Comment]

likeables.each do |likeable|
  random_likeables = likeable.constantize
                             .all
                             .sample(likeable.constantize.count * 0.6)
  random_likeables.each do |likeable_object|
    random_users = User.all
                       .sample(rand(1..(MULTIPLIER * 0.4)))

    random_users.each do |user|
      likeable_object
        .likes
        .create(user: user)
    end
  end
end

print "#{Like.count} created..."
puts 'done!'

puts 'Done with everything!'
