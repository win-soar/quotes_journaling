require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'バリデーション' do
    it 'メールアドレスがなければ無効である' do
      user = User.new(email: '', password: 'password', password_confirmation: 'password', name: 'テストマン')
      expect(user).not_to be_valid
    end

    it '重複したメールアドレスは無効である' do
      User.create(email: 'test@example.com', password: 'password', password_confirmation: 'password', name: 'テストマン')
      user = User.new(email: 'test@example.com', password: 'password123', password_confirmation: 'password123', name: 'テストマン')
      expect(user).not_to be_valid
    end

    it 'パスワードが短すぎると無効である（6文字未満）' do
      user = User.new(email: 'short@example.com', password: '123', password_confirmation: '123', name: 'テストマン')
      expect(user).not_to be_valid
    end

    it '名前がなければ無効である' do
      user = User.new(email: 'test@example.com', password: 'password', password_confirmation: 'password', name: '')
      expect(user).not_to be_valid
    end

    it 'すべての項目が揃っていれば有効である' do
      user = User.new(email: 'test@example.com', password: 'password', password_confirmation: 'password', name: 'テストマン')
      expect(user).to be_valid
    end
  end
end
