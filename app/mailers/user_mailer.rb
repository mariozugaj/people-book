# frozen_string_literal: true

class UserMailer < ApplicationMailer
  default from: 'welcome@peoplebook.com'

  def welcome(user)
    @user = user
    mail to: user.email, subject: 'Welcome to PeopleBook'
  end
end
