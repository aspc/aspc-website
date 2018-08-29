class CourseMeetingDetail < ApplicationRecord
  enum campus: [ :unknown, :pomona, :claremont_mckenna, :harvey_mudd, :scripps, :pitzer ]
end
