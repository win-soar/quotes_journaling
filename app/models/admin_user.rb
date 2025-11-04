class AdminUser < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, 
         :recoverable, :rememberable, :validatable

  # ActiveAdmin + Ransack 4.x対応: 検索許可属性を明示
  def self.ransackable_attributes(_auth_object = nil)
    %w[id email created_at updated_at remember_created_at reset_password_sent_at]
  end
end
