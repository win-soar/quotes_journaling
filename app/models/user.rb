class User < ApplicationRecord
  authenticates_with_sorcery!

  has_many :quotes
  has_many :likes, dependent: :destroy
  has_many :liked_quotes, through: :likes, source: :quote
  has_many :comments, dependent: :destroy
  has_one_attached :avatar

  validates :email, presence: true, uniqueness: true
  validates :name, presence: true
  validates :password, length: {minimum: 6 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> {new_record? || changes[:crypted_password] }
  validate :avatar_type

  def liked?(quote)
    likes.exists?(quote_id: quote.id)
  end

  def self.ransackable_attributes(auth_object = nil)
    ["bio", "created_at", "crypted_password", "email", "id", "id_value", "name", "password_digest", "salt", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["quotes", "likes", "comments", "avatar"]
  end

  private

  def avatar_type
    return unless avatar.attached?
    unless avatar.image?
      errors.add(:avatar, 'は画像ファイルを選択してください')
      avatar.purge
    end
  end
end
