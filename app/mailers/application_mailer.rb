# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'info@peoplebook.com'
  layout 'mailer'
end
