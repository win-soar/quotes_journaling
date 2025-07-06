class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :quote
  has_many :reports, as: :reportable, dependent: :destroy

  validates :body, presence: true
  validates :user, presence: true

  def self.ransackable_attributes(auth_object = nil)
    ["body", "created_at", "id", "id_value", "quote_id", "updated_at", "user_id"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["user", "quote"]
  end
end
