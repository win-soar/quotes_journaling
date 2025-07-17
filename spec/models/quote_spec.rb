require 'rails_helper'

RSpec.describe Quote, type: :model do
  let(:user) { User.create(email: 'test@example.com', password: 'password') }

  describe 'バリデーション' do
    it 'タイトルがなければ無効である' do
      quote = Quote.new(title: '', note: 'メモ', author: '誰か', source: '本', user: user, category: 1)
      expect(quote).not_to be_valid
    end

    it 'noteがなければ無効である' do
      quote = Quote.new(title: '名言', note: '', author: '誰か', source: '本', user: user, category: 1)
      expect(quote).not_to be_valid
    end

    it 'authorがなければ無効である' do
      quote = Quote.new(title: '名言', note: 'メモ', author: '', source: '本', user: user, category: 1)
      expect(quote).not_to be_valid
    end

    it 'categoryがなければ無効である' do
      quote = Quote.new(title: '名言', note: 'メモ', author: '誰か', source: '本', user: user, category: '')
      expect(quote).not_to be_valid
    end

    it 'すべての項目が揃っていれば有効である' do
      quote = Quote.new(title: '名言', note: 'メモ', author: '誰か', source: '本', user: user, category: 1)
      expect(quote).to be_valid
    end
  end
end
