class CreateLatestNews < ActiveRecord::Migration[5.2]
  def change
    create_table :latest_news do |t|
      t.string :title
      t.string :caption
      t.string :details_url
      t.integer :priority

      t.timestamps
    end
  end
end
