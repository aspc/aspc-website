class RenameContentToPendingContent < ActiveRecord::Migration[5.2]
  def change
    rename_column :statics, :content, :pending_content
  end
end
