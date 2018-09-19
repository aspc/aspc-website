class CreateAnnouncements < ActiveRecord::Migration[5.2]
  def change
    create_table :announcements do |t|
      t.text :title, :null => false
      t.text :caption
      t.string :details_url

      t.timestamps
    end
  end
end
