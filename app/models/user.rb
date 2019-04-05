class User < ApplicationRecord
  has_one :course_schedule

  validates :email, :presence => true, :uniqueness => true
  validates :first_name, :presence => true
  validate :is_password_necessary
  validate :is_role_valid

  enum school: [ :unknown, :pomona, :claremont_mckenna, :harvey_mudd, :scripps, :pitzer ]
  enum role: { :admin => 0, :contributor => 1 }

  def is_password_necessary
    return if is_cas_authenticated

    if password.blank?
      errors.add(:password, 'needs to be present if is_cas_authenticated is false')
    end
  end

  def is_role_valid
    if is_admin && role.blank?
      errors.add(:is_admin, 'must have a role if designated as admin')
    end

    if role.present? and not is_admin
      errors.add(:role, 'may be set only on user designated as admin')
    end
  end
end
