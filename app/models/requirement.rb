class Requirement < ApplicationRecord
  has_and_belongs_to_many :courses
end
