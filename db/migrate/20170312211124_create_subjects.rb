class CreateSubjects < ActiveRecord::Migration[5.0]
  def change
    create_table :subjects do |t|
      t.text  :subject_text
      t.timestamps
    end
  end
end
