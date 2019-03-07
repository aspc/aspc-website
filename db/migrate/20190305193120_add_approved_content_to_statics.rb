class AddApprovedContentToStatics < ActiveRecord::Migration[5.2]
  def change
    add_column :statics, :approved_content, :text
  end
end
