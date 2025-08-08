class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :quotes, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :liked_quotes, through: :likes, source: :quote
  has_many :comments, dependent: :destroy
  has_many :reports, dependent: :destroy
  has_one_attached :avatar

  validates :email, presence: true, uniqueness: true
  validates :name, presence: true
  validates :password, length: {minimum: 6 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, presence: true, if: -> { provider.blank? && (new_record? || changes[:crypted_password]) }
  validates :password_confirmation, presence: true, if: -> {new_record? || changes[:crypted_password] }
  validate :avatar_type

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2]

  def liked?(quote)
    likes.exists?(quote_id: quote.id)
  end

  def self.ransackable_attributes(auth_object = nil)
    ["bio", "created_at", "crypted_password", "email", "id", "id_value", "name", "password_digest", "salt", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["quotes", "likes", "comments", "avatar", "reports"]
  end

  def self.from_omniauth(auth)
    user = where(provider: auth.provider, uid: auth.uid).first_or_initialize
    user.email ||= auth.info.email
    generated_password = Devise.friendly_token[0, 20]
    user.password = generated_password
    user.password_confirmation = generated_password
    user.name ||= auth.info.name

    Rails.logger.error "Save failed: #{user.errors.full_messages}" unless user.save
    user
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
