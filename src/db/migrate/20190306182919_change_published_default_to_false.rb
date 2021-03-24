class ChangePublishedDefaultToFalse < ActiveRecord::Migration[5.2]
  def change
    change_column_default :statics, :published, false
  end
end
