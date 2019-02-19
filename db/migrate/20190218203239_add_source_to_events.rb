class AddSourceToEvents < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :source, :integer, :default => 0
  end
end
