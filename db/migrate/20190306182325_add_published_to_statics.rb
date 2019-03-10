class AddPublishedToStatics < ActiveRecord::Migration[5.2]
  def change
    add_column :statics, :published, :boolean
  end
end
