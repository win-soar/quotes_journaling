class Quote < ApplicationRecord
  belongs_to :user
  has_many :likes, dependent: :destroy
  has_many :liked_users, through: :likes, source: :user
  has_many :comments

  validates :title, :author, :note, :category, presence: true

  enum category: {
    historical: 1,
    celebrity: 2,
    fictional: 3,
    original: 4
  }
end
