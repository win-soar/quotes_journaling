class Like < ApplicationRecord
  belongs_to :user
  belongs_to :quote

  validates :user_id, uniqueness: { scope: :quote_id }

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "id", "id_value", "quote_id", "updated_at", "user_id"]
  end
end
