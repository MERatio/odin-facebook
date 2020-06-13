module UsersHelper
  def current_user?(user)
    current_user == user
  end

  def gravatar_for(user, size: 180)
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag(gravatar_url, alt: user.full_name)
  end
end
