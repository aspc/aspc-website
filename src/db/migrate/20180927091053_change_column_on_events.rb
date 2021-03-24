class ChangeColumnOnEvents < ActiveRecord::Migration[5.2]
  def change
    change_column_null :events, :college_affiliation, false, 0
    change_column_default :events, :college_affiliation, 0
  end
end
