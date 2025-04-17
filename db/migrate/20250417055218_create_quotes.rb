class CreateQuotes < ActiveRecord::Migration[7.1]
  def change
    create_table :quotes do |t|
      t.string :title
      t.string :author
      t.string :note
      t.string :source
      t.string :source_writer
      t.string :image
      t.integer :category
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
