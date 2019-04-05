module StaticHelper

  # Profile picture image helper for senator/staff profiles
  def avatar_photo (person)
    if person.image.attached?
      image_tag person.image
    else
      image_tag "static/placeholder.jpg"
    end
  end

end
