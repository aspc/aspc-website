class User < ApplicationRecord
  has_one :course_schedule

  enum school: [ :unknown, :pomona, :claremont_mckenna, :harvey_mudd, :scripps, :pitzer ]
end
