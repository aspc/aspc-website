class CreateRequirements < ActiveRecord::Migration[5.2]
  def change
    create_table :requirements do |t|
      t.string :code, :null => false, :unique => true
      t.string :name, :null => false

      t.timestamps
    end

    add_index(:requirements, :code, :unique => true)
  end
end
