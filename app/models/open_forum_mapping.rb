class OpenForumMapping < ApplicationRecord
  validates :topic, presence: true
  validates :email, presence: true
end
