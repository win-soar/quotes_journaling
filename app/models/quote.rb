class Quote < ApplicationRecord
  belongs_to :user
  has_many :like_quotes
  has_many :comments
  has_one :title
  has_one :author
  has_one :note
  has_one :source
  has_one :source_writer
  has_one :category

  validates :title, presence: true
  validates :author, presence: true
  validates :note, presence: true
  validates :category, presence: true
end
