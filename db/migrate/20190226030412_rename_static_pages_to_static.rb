class RenameStaticPagesToStatic < ActiveRecord::Migration[5.2]
  def change
    rename_table :static_pages, :statics
  end
end
