# frozen_string_literal: true

module PicsHelper
  def picture_as_thumbnail(pic)
    pic.variant(resize_to_limit: [150, 150]).processed
  end

  def allowed_pic?(pic)
    pic.attached? && pic.content_type.in?(%w[image/jpeg image/gif images/png])
  end
end
