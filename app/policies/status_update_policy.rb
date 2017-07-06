class StatusUpdatePolicy
  attr_reader :author, :status_update

  def initialize(author, status_update)
    @author = author
    @status_update = status_update
  end

  def create?
    true
  end

  def edit?
    owner?
  end

  def update?
    owner?
  end

  def comment?
    current_author.friend_with? author
  end

  private

  def owner?
    author == status_update.author
  end
end
