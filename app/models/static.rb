class Static < ApplicationRecord
  validates_uniqueness_of :page_name, :allow_nil => true, :allow_blank => true # allows nil fields
  validate :can_publish?

  belongs_to :last_modified_by, class_name: "User", foreign_key: "last_modified_by"

  def approve!
    self.approved_content = self.pending_content

    self.published = true
    self.save
  end

  private

  def can_publish?
    if self.published == true
      if self.page_name.blank?
        errors.add(:page_name, "cannot be empty")
      end

      if Static.where.not(:id => self.id).exists?(:page_name => self.page_name)
        errors.add(:page_name, "must be unique")
      end
    end

    return errors.nil? # Return true if can publish
  end

end
