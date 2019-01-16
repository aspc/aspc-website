module ApplicationHelper
  def person_photo (person)
    if person.image.attached?
      image_tag person.image
    else
      image_tag "static/placeholder.png"
    end
  end
end
