require 'rails_helper'

RSpec.describe Report, type: :model do
  let(:user)  { User.create!(email: 'test@example.com', password: 'password', password_confirmation: 'password', name: 'テストマン', agree_terms: '1') }
  let(:quote) { Quote.create!(title: '名言', note: 'note', author: 'author', source: 'source', user: user, category: 1) }

  describe 'バリデーション' do
    it '理由がなければ無効である' do
      report = Report.new(reason: '')
      expect(report).not_to be_valid
    end

    it '理由が短すぎると無効である（10文字未満）' do
      report = Report.new(reason: '123456789')
      expect(report).not_to be_valid
    end

    it 'すべての項目が揃っていれば有効である' do
      report = Report.new(reason: '12345678910')
      expect(user).to be_valid
    end
  end

  describe 'アソシエーション' do
    it 'belongs to a polymorphic reportable' do
      association = Report.reflect_on_association(:reportable)
      expect(association.macro).to eq(:belongs_to)
      expect(association.options[:polymorphic]).to be true
    end
    it { should belong_to(:user) }
  end
end
