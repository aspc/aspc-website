class AddColumnsToEvent < ActiveRecord::Migration[5.2]
  def change
    # Add college affiliation field
    add_column :events, :college_affiliation, :integer
    add_index :events, :college_affiliation

    # Make sure submitted_by is not null (legacy ones just set to first user)
    change_column_null :events, :submitted_by_user_fk, false, 0
  end
end
