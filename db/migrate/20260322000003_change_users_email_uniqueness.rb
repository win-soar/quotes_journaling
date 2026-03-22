class ChangeUsersEmailUniqueness < ActiveRecord::Migration[7.1]
  def change
    remove_index :users, name: "index_users_on_email"

    # グローバルユーザー（circle_id IS NULL）はメール単体でユニーク
    add_index :users, :email, unique: true,
              where: "circle_id IS NULL",
              name: "index_users_on_email_global_unique"

    # サークル内ではメール+circle_idの組み合わせでユニーク
    add_index :users, [:email, :circle_id], unique: true,
              name: "index_users_on_email_and_circle_id"
  end
end
