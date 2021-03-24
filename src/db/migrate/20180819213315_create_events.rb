class CreateEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :events do |t|
      t.text :name, :null => false
      t.datetime :start, :null => false
      t.datetime :end, :null => false
      t.text :location, :null => false
      t.text :description, :null => false
      t.text :host
      t.text :details_url
      t.integer :status, :null => false, :default => 0

      t.integer :submitted_by_user_fk

      t.timestamps
    end

    add_index(:events, :status)
  end
end
