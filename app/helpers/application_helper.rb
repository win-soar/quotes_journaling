module ApplicationHelper
  def image_attachment?(attachment)
    attachment.connect_type.start_with?('image')
  end

  def avatar_image_tag(user, size: "50x50")
    if user.avatar.attached?
      url = if Rails.env.production?
              "https://780948cb2236cfafee48ef8bc1fab47c.r2.cloudflarestorage.com/#{user.avatar.key}"
            else
              url_for(user.avatar)
            end
      image_tag(url, size: size)
    else
      image_tag('/images/default_avatar.png', size: size)
    end
  end
end
