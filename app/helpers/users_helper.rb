# Andre Haas

module UsersHelper
  # From www.railstutorial.org
  # Returns the Gravatar for the given user.
  def gravatar_for(user, options = { size: 80 })
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    size = options[:size]
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag(gravatar_url, alt: user.name, class: "gravatar")
  end

  def homepage_for(user)
    if user.household.nil?
      return invites_path
    else
      return home_path
    end
  end
end
