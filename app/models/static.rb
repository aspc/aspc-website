class Static < ApplicationRecord
  def approve!
    self.approved_content = self.pending_content
    self.published = true
    self.save
  end
end
