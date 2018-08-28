class Event < ApplicationRecord
  enum status: [ :pending, :approved, :rejected]

  has_one :submitted_by, class_name: "User", foreign_key: "submitted_by_user_fk"

  def approve!
    self.update_attribute :status, :approved
  end

  def reject!
    self.update_attribute :status, :rejected
  end
end