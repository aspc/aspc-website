module ApplicationHelper
  def person_photo person
    if person.image.present?
      image_tag user.image_url
    else
      image_tag "static/placeholder.png"
    end
  end
end
