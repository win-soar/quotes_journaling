class ChangeQuoteForeignKey < ActiveRecord::Migration[7.1]
  def change
    remove_foreign_key :quotes, :users
    add_foreign_key :quotes, :users
  end
end
