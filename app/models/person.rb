class Person < ApplicationRecord
  enum role: [:senator, :staff]
end
