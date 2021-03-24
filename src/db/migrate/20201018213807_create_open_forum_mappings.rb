class CreateOpenForumMappings < ActiveRecord::Migration[5.2]
  def change
    create_table :open_forum_mappings do |t|
      t.string :topic
      t.string :email

      t.timestamps
    end
  end
end
