class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.text :email, :unique => true, :null => false
      t.text :first_name, :null => false
      t.boolean :is_cas_authenticated, :null => false
      t.boolean :is_admin, :null => false, :default => false
      t.integer :school, :null => false, :default => 0
      t.timestamps
    end

    add_index(:users, :email, :unique => true)
    add_index(:users, :is_admin)
  end
end
