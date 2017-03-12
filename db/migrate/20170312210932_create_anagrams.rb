class CreateAnagrams < ActiveRecord::Migration[5.0]
  def change
    create_table :anagrams do |t|
      t.text  :anagram_text
      t.integer :subject_id
      t.timestamps
    end
  end
end
