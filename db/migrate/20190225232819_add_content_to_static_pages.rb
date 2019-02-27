class AddContentToStaticPages < ActiveRecord::Migration[5.2]
  def change
    add_column :static_pages, :content, :text
  end
end
