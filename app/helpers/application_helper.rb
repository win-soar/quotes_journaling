module ApplicationHelper
  def image_attachment?(attachment)
    attachment.connect_type.start_with?('image')
  end
end
