# PeopleBook

PeopleBook is a social network clone built with the power of Ruby on Rails. View the [demo](https://peoplebook.mariozugaj.com/).

You can sign in and explore using multiple **prepopulated accounts**:

```
email: user_0@example.com (all the way through 4)
password: password
```

### Technical notes

* Backend built using **Ruby on Rails 5.2**
* Frontend interactions built using **Javascript** (mostly ES6)
* Database (Postgres) seeded using **Faker gem, wikipedia and mashape APIs**
* Real time conversations and appearance status pushed to clients using **ActionCable** and **Redis**
* **AWS S3** used for image storage, **Carrierwave** for uploading and transformations
* Styled using **SemanticUI**
* Frontend form validation and autocomplete built using SemanticUI API
* Search is powered by **ElasticSearch and Searchick gem**
* Log in / sign up through Facebook using **Omniauth**
* Tests written using **Minitest**
* Hosted on **Heroku**

### Features

* Signup or login using Facebook authentication
* Send friend requests / accept friend requests
* Post status updates on your own timeline
* See friend's recent status updates on the home page
* Comment on friend's status updates
* Like anyones status updates, comments and images
* See who liked what (max 5 most recent people) by hovering over likes
* Create new photo albums, upload new images or link from other sources
* Set uploaded images as avatar or cover photo
* Update your profile info to reflect who you are
* Start new conversations with friends, exchange messages
* Receive notifications about various friend's activities
* Search people, status updates, images, comments

### Sneak peek

![Landing](https://s3.eu-central-1.amazonaws.com/github-readme-screenshots/people_book/1_landing.png)
![Sign up through fb](https://s3.eu-central-1.amazonaws.com/github-readme-screenshots/people_book/2_fb_auth.png)
![Comments, likes](https://s3.eu-central-1.amazonaws.com/github-readme-screenshots/people_book/3_comments_likes.png)
![Profile](https://s3.eu-central-1.amazonaws.com/github-readme-screenshots/people_book/4_profile.png)
![Autocomplete](https://s3.eu-central-1.amazonaws.com/github-readme-screenshots/people_book/5_autocomplete.png)
![Search](https://s3.eu-central-1.amazonaws.com/github-readme-screenshots/people_book/6_search_results.png)
![Friend requests](https://s3.eu-central-1.amazonaws.com/github-readme-screenshots/people_book/7_friend_requests.png)
![Image](https://s3.eu-central-1.amazonaws.com/github-readme-screenshots/people_book/8_image.png)
![Conversations](https://s3.eu-central-1.amazonaws.com/github-readme-screenshots/people_book/9_conversations.png)


