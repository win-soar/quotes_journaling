class Quote < ApplicationRecord
  belongs_to :user
  has_many :likes, dependent: :destroy
  has_many :liked_users, through: :likes, source: :user
  has_many :comments, dependent: :destroy

  validates :title, :author, :note, :category, presence: true

  enum category: {
    historical: 1,
    celebrity: 2,
    fictional: 3,
    original: 4
  }

  def self.ransackable_associations(auth_object = nil)
    ["user", "likes", "liked_users", "comments"]
  end

  def self.ransackable_attributes(auth_object = nil)
    ["id", "title", "note", "author", "source", "source_writer", "category", "created_at", "updated_at"]
  end
end
