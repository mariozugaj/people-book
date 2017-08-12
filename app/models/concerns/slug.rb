module Slug
  extend ActiveSupport::Concern

  included do
    acts_as_url :uuid, url_attribute: :slug
  end

  def to_param
    self.slug
  end

  private

  def uuid
    Random.new.rand(1_000_000...10_000_000)
  end
end
