class AddPriorityToAnnouncements < ActiveRecord::Migration[5.2]
  def change
    add_column :announcements, :priority, :integer
  end
end
