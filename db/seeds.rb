# Users

MULTIPLIER = 50

MULTIPLIER.times do |index|
  User.create!(name: "#{Faker::Name.first_name} #{Faker::Name.last_name}",
               email: "user_#{index}@example.com",
               password: "password#{index}")
end

# Profiles

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
                        'Widowed']
User.all.each do |user|
  user.profile.update!(birthday: Faker::Date.between(60.years.ago, 18.years.ago),
                       education: Faker::University.name,
                       hometown: Faker::Address.city,
                       profession: Faker::Job.title,
                       company: Faker::Company.name,
                       relationship_status: RELATIONSHIP_OPTIONS[rand(9)],
                       phone_number: Faker::PhoneNumber.cell_phone,
                       about: Faker::Lorem.paragraph)
end

# Status updates
require 'wikipedia'

User.all.each do |user|
  (MULTIPLIER / 5).times do
    user.status_updates.create(text: Wikipedia.find_random.summary)
  end
end
