class LatestNews < ApplicationRecord
    scope :priority_order, -> {order(priority: :asc)}
end
