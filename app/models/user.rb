class User < ApplicationRecord
  enum school: [ :unknown, :pomona, :claremont_mckenna, :harvey_mudd, :scripps, :pitzer ]
end
