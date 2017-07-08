module ProfileHelper

  def profile_default(user, profile_column, content = nil)
    return profile_column.to_s.humanize.capitalize if user.profile.try(profile_column).blank?
    "#{content} #{user.profile.send(profile_column)}" || user.profile.send(profile_column)
  end
end
