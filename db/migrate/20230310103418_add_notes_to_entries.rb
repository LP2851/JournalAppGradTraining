class AddNotesToEntries < ActiveRecord::Migration[7.0]
  def change
    add_column :entries, :notes, :string
  end
end
