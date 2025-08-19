class CreateLineEvents < ActiveRecord::Migration[7.1]
  def change
    create_table :line_events do |t|
      t.string :event_type
      t.string :user_id
      t.text :message
      t.jsonb :payload

      t.timestamps
    end
  end
end
