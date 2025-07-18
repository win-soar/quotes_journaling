module ApplicationHelper
  def image_attachment?(attachment)
    attachment.content_type.start_with?('image')
  end

  def public_avatar_url(user)
    return unless user.avatar.attached?
    key = user.avatar.blob.key
    "https://pub-d429bdd697654555854a5476f306215c.r2.dev/#{key}"
  end

  def avatar_image_tag(user, size: "50x50")
    return image_tag('/images/default_avatar.png', size: size) unless user.avatar.attached?

    if Rails.env.production?
      url = public_avatar_url(user)
      image_tag(url, size: size)
    else
      url = url_for(user.avatar)
      image_tag(url, size: size)
    end
  end
end
