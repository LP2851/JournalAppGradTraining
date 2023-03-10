class CreateEntryTaggings < ActiveRecord::Migration[7.0]
  def change
    create_table :entry_taggings do |t|
      t.belongs_to :tag, null: false, foreign_key: true
      t.belongs_to :entry, null: false, foreign_key: true

      t.timestamps
    end
  end
end
