class CreateCircles < ActiveRecord::Migration[7.1]
  def change
    create_table :circles do |t|
      t.string :name, null: false
      t.text :description
      t.string :join_token, null: false
      t.string :circle_password_digest, null: false

      t.timestamps
    end

    add_index :circles, :join_token, unique: true
  end
end
