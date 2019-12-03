module StaticHelper

  # Method used to set a class based on event's college affiliation in events slideshow on homepage
  def bg_color_class(item)
    case item.college_affiliation.try(:to_sym)
    when :pomona
      "event-PO"
    when :claremont_mckenna
      "event-CM"
    when :harvey_mudd
      "event-HM"
    when :scripps
      "event-SC"
    when :pitzer
      "event-PZ"
    else
      "event-PO" # catchall because Frank/Frary/Oldenborg to not symbolize to Pomona
    end
  end

  # Profile picture image helper for senator/staff profiles
  def avatar_photo (person)
    if person.image.attached?
      image_tag person.image
    else
      image_tag "static/placeholder.jpg"
    end
  end

end
