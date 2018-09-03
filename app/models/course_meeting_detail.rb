class CourseMeetingDetail < ApplicationRecord
  enum campus: [ :unknown, :pomona, :claremont_mckenna, :harvey_mudd, :scripps, :pitzer ]

  def days(options = {})
    days = {
        :monday => self.monday,
        :tuesday => self.tuesday,
        :wednesday => self.wednesday,
        :thursday => self.thursday,
        :friday => self.friday
    }

    if options[:present_only]
      days.select! {|k,v| v}
    end

    days
  end

  def formatted_days
    s = []
    days = self.days :present_only => true

    s << "M" if days[:monday]
    s << "T" if days[:tuesday]
    s << "W" if days[:wednesday]
    s << "R" if days[:thursday]
    s << "F" if days[:friday]

    if s.blank?
      nil
    else
      s.join(" ")
    end
  end

  def formatted_start_time
    _format_time(self.start_time) if self.start_time
  end

  def formatted_end_time
    _format_time(self.end_time) if self.end_time
  end

  def formatted_time
    start_format_time = self.formatted_start_time
    end_format_time = self.formatted_end_time

    if start_format_time && end_format_time
      "#{start_format_time} - #{end_format_time}"
    else
      "To Be Announced"
    end
  end

  def to_s
    if !self.campus_abbreviation
      ""
    elsif !self.formatted_days
      "#{self.campus_abbreviation} - Days/Time TBA"
    else
      "#{self.campus_abbreviation} - #{self.formatted_days} - #{self.formatted_time}"
    end
  end

  def campus_abbreviation
    case self.campus.to_sym
    when :unknown
      nil
    when :pomona
      "PO"
    when :claremont_mckenna
      "CM"
    when :harvey_mudd
      "HM"
    when :scripps
      "SC"
    when :pitzer
      "PZ"
    end
  end

  private
    def _format_time(time)
      return time.strftime("%I:%M%P")
    end
end
