class AddCircleIdToUsers < ActiveRecord::Migration[7.1]
  def change
    add_reference :users, :circle, null: true, foreign_key: true
  end
end
