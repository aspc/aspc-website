class AddColumnsToStatic < ActiveRecord::Migration[5.2]
  def change
    add_column :statics, :page_name, :string, unique: true
    add_index :statics, :page_name, unique: true
  end
end
