class CreateVocabs < ActiveRecord::Migration[5.0]
  def change
    create_table :vocabs do |t|
      t.string  :word_string
      t.timestamps
    end
  end
end
