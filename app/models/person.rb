class Person < ApplicationRecord
  enum role: [:senator => 0, :staff => 1]
end
