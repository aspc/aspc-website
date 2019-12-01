class ChangeSubmittedByUserFkColumnOnUsers < ActiveRecord::Migration[5.2]
  def change
    change_column_null :events, :submitted_by_user_fk, true
  end
end
