class HomeController < ApplicationController
  def index
    @new_status_update = StatusUpdate.new
    @new_status_update.image_attachment = ImageAttachment.new
    @feed = StatusUpdate.all
  end
end
