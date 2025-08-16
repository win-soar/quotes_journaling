class AddLineFieldsToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :line_display_name, :string
  end
end
