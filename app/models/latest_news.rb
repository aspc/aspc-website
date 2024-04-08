class LatestNews < ApplicationRecord
    scope :priority_order, -> {order(priority: :asc)}
    validates :title, presence: true
    validates :priority, presence: true
end
