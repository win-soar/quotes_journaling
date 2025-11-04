class User < ApplicationRecord
  attr_accessor :agree_terms

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[google_oauth2 line]

  has_many :quotes, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :liked_quotes, through: :likes, source: :quote
  has_many :comments, dependent: :destroy
  has_many :reports, dependent: :destroy
  has_one_attached :avatar

  validates :email, presence: true, uniqueness: true
  validates :name, presence: true
  validates :password, presence: true, length: { minimum: 6 }, if: :password_required?
  validates :password_confirmation, presence: true, if: :password_required?
  validate :avatar_type
  validate :terms_agreement_required, on: :create, unless: :google_authenicated?

  def liked?(quote)
    likes.exists?(quote_id: quote.id)
  end

  def google_authenicated?
    provider == "google_oauth2"
  end

  class << self
    def ransackable_attributes(auth_object = nil)
      ["bio", "created_at", "crypted_password", "email", "id", "id_value", "name", "password_digest", "salt", "updated_at"]
    end

    def ransackable_associations(auth_object = nil)
      ["quotes", "likes", "comments", "avatar", "reports"]
    end

    def from_omniauth(auth)
      user = where(provider: auth.provider, uid: auth.uid).first_or_initialize
      user.email ||= auth.info.email
      generated_password = Devise.friendly_token[0, 20]
      user.password = generated_password
      user.password_confirmation = generated_password
      user.name ||= auth.info.name

      Rails.logger.error "Save failed: #{user.errors.full_messages}" unless user.save
      user
    end

    def from_line_omniauth(auth)
      user = where(line_user_id: auth.uid).first_or_initialize
      user.assign_attributes(
        line_display_name: auth.info.name,
        line_user_id: auth.uid
      )
      user.save
      user
    end

    def with_line_account
      where.not(line_user_id: nil)
    end
  end

  private

  def avatar_type
    return unless avatar.attached?
    unless avatar.image?
      errors.add(:avatar, 'は画像ファイルを選択してください')
      avatar.purge
    end
  end

  def password_required?
    provider.blank? && (new_record? || password.present?)
  end

  def terms_agreement_required
    errors.add(:base, "利用規約とプライバシーポリシーへの同意が必要です。") if agree_terms != "1"
  end
end
