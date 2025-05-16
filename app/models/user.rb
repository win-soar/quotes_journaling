class User < ApplicationRecord
  authenticates_with_sorcery!

  has_many :quotes
  has_many :like_quotes
  has_many :comments
  has_one_attached :avatar

  validates :email, presence: true, uniqueness: true
  validates :name, presence: true
  validates :password, length: {minimum: 6 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> {new_record? || changes[:crypted_password] }
  validate :avatar_type

  private

  def avatar_type
    return unless avatar.attached?
    unless avatar.image?
      errors.add(:avatar, 'は画像ファイルを選択してください')
      avater.purge
    end
  end
end
