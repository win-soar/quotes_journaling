class Circle < ApplicationRecord
  has_secure_password :circle_password

  has_many :users, dependent: :destroy

  validates :name, presence: true
  validates :join_token, uniqueness: true, allow_nil: false, if: :join_token

  before_validation :generate_join_token, on: :create

  def member_count
    users.count
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[id name description join_token created_at updated_at]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[users]
  end

  private

  def generate_join_token
    self.join_token ||= SecureRandom.urlsafe_base64(16)
  end
end
