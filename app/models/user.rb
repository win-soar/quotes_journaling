class User < ApplicationRecord
  authenticates_with_sorcery!

  has_many :quotes
  has_many :like_quotes
  has_many :comments

  validates :email, presence: true, uniqueness: true
  validates :name, presence: true
  validates :password, length: {minimum: 6 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> {new_record? || changes[:crypted_password] }
end
