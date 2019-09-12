class AddPriorityToPerson < ActiveRecord::Migration[5.2]
  def change
    add_column :people, :priority, :integer
  end
end