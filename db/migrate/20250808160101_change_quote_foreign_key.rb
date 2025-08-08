class ChangeQuoteForeignKey < ActiveRecord::Migration[7.1]
  def change
    remove_foreign_key :quotes, name: 'fk_rails_02b555fb4d'
    add_foreign_key :quotes, :users,
      column: :user_id,
      name: 'fk_rails_02b555fb4d',
      on_delete: :cascade
  end
end
