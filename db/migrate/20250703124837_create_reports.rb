class CreateReports < ActiveRecord::Migration[7.1]
  def change
    create_table :reports do |t|
      t.references :reportable, polymorphic: true, null: false
      t.text :reason
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
