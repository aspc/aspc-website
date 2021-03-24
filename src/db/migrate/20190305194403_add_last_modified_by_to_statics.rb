class AddLastModifiedByToStatics < ActiveRecord::Migration[5.2]
  def change
    add_column :statics, :last_modified_by, :integer
  end
end
