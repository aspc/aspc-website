class CreatePomonaEventMaps < ActiveRecord::Migration[5.2]
  def change
    create_table :pomona_event_maps do |t|
      t.text :event_id
      t.text :mapped_id

      t.timestamps
    end
  end
end
