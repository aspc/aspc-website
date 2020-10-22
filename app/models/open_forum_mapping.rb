class OpenForumMapping < ApplicationRecord
  validates :topic, presence: true
  validates :email, presence: true

  default_scope { order(topic: :asc) }
end
