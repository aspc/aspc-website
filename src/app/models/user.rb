class User < ApplicationRecord
  has_one :course_schedule
  has_many :housing_reviews

  validates :email, :presence => true, :uniqueness => true
  validates  :role, :presence => true
  validates :first_name, :presence => true
  validate :is_password_necessary

  enum school: [ :unknown, :pomona, :claremont_mckenna, :harvey_mudd, :scripps, :pitzer ]
  enum role: { :user => 0, :admin => 1, :contributor => 2 }

  def is_password_necessary
    return if is_cas_authenticated

    if password.blank?
      errors.add(:password, 'needs to be present if is_cas_authenticated is false')
    end
  end
end
