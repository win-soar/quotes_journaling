module ApplicationHelper
  def image_attachment?(attachment)
    attachment.content_type.start_with?('image')
  end

  def public_avatar_url(user)
    return unless user.avatar.attached?

    if Rails.env.production?
      user.avatar.blob.service_url.gsub(
        %r{https://[^/]+/quotesjournaling-avatar-bucket},
        "https://pub-d429bdd697654555854a5476f306215c.r2.dev"
      )
    else
      url_for(user.avatar)
    end
  end

  def avatar_image_tag(user, size: "50x50")
    url = public_avatar_url(user) || '/images/default_avatar.png'
    image_tag(url, size: size)
  end
end
