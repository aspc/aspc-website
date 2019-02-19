class Event < ApplicationRecord
  enum status: [ :pending, :approved, :rejected]
  enum college_affiliation: [:all_colleges, :pomona, :claremont_mckenna, :harvey_mudd, :scripps, :pitzer]
  enum source: [:manual, :facebook]

  belongs_to :submitted_by, class_name: "User", foreign_key: "submitted_by_user_fk"

  validates :name, presence: true
  validates :start, presence: true
  validates :end, presence: true
  validates :location, presence: true
  validates :description, presence: true
  validates :submitted_by_user_fk, presence: true
  validates :college_affiliation, presence: true

  def approve!
    self.update_attribute :status, :approved
  end

  def reject!
    self.update_attribute :status, :rejected
  end
end