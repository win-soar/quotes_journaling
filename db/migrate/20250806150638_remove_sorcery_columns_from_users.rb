class RemoveSorceryColumnsFromUsers < ActiveRecord::Migration[7.1]
  def up
    change_table :users, bulk: true do |t|
      t.remove :crypted_password
      t.remove :salt
    end
  end

  def down
    change_table :users, bulk: true do |t|
      t.string :crypted_password
      t.string :salt
    end
  end
end
