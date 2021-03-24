class CreateAcademicTerms < ActiveRecord::Migration[5.2]
  def change
    create_table :academic_terms do |t|
      t.string :key
      t.string :session
      t.integer :year

      t.timestamps
    end
  end
end
